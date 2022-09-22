SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[UpdateMustScoreForAll] (@StudyId INT) AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @WeightId INT = 3224;
	DECLARE @HeightId INT = 3225;

	-- Create temporary table for must-score and alert-data
	CREATE TABLE #temp (
		PersonId INT PRIMARY KEY NOT NULL,
		EventTime DATETIME,
		Weight DECIMAL(18, 4),
		Height DECIMAL(18, 4),
		BMI DECIMAL(18, 4),
		PercentChange DECIMAL(18, 4),
		NoOfWeights INT,
		MustScore INT,
		MsgText VARCHAR(512),
		MsgHeader VARCHAR(24),
		AlertFacet VARCHAR(16),
		AlertLevel INT
	);

	-- Populate #temp with candidates
	INSERT INTO #temp (PersonId)
		SELECT PersonId
		FROM dbo.ViewActiveCaseListStub sc
		WHERE sc.StudyId = @StudyId;

	-- Add weight
	MERGE
	INTO #temp a
	USING (SELECT PersonId, Quantity, EventTime
		FROM (SELECT ce.PersonId, cdp.Quantity, ce.EventTime, RANK() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventTime DESC) AS RNK
			FROM dbo.ClinDataPoint cdp
			JOIN dbo.ClinEvent ce
				ON ce.EventId = cdp.EventId AND ce.StudyId = @StudyId
			JOIN #temp t
				ON t.PersonId = ce.PersonId
			WHERE cdp.ItemId = @WeightId
			AND cdp.Quantity > 1) a
		WHERE rnk = 1) b
	ON (b.PersonId = a.PersonId)
	WHEN MATCHED
		THEN UPDATE
			SET Weight = b.Quantity, EventTime = b.EventTime;

	-- Add height & BMI
	MERGE
	INTO #temp a
	USING (SELECT PersonId, Quantity
		FROM (SELECT ce.PersonId, cdp.Quantity, RANK() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventTime DESC) AS RNK
			FROM dbo.ClinDataPoint cdp
			JOIN dbo.ClinEvent ce
				ON ce.EventId = cdp.EventId AND ce.StudyId = @StudyId
			JOIN #temp t
				ON t.PersonId = ce.PersonId
			WHERE cdp.ItemId = @HeightId
			AND cdp.Quantity > 1) a
		WHERE rnk = 1) b
	ON (b.PersonId = a.PersonId)
	WHEN MATCHED
		THEN UPDATE
			SET Height = b.Quantity, BMI = 10000 * Weight / b.Quantity / b.Quantity;

	-- Add PercentChange, and set MustScore when PercentChange < -5
	MERGE
	INTO #temp a
	USING (SELECT ce.PersonId, MIN(100 * (t.Weight / cdp.Quantity - 1)) AS Change
		FROM dbo.ClinEvent ce
		JOIN dbo.ClinDataPoint cdp
			ON cdp.EventId = ce.EventId AND cdp.ItemID = @WeightId AND cdp.Quantity
			> 0
		JOIN #temp t
			ON t.PersonId = ce.PersonId AND ce.EventTime < t.EventTime
		WHERE CONVERT(FLOAT, t.EventTime - ce.EventTime) < 180
		AND ce.StudyId = @StudyId
		GROUP BY ce.PersonId) b
	ON (a.PersonId = b.PersonId)
	WHEN MATCHED
		THEN UPDATE
			SET PercentChange = b.Change,
			MustScore =
						CASE
							WHEN b.Change < -10 THEN 2
							WHEN (b.Change >= -10 AND
								b.Change < -5) THEN 1
						END,
			MsgText =
						CASE
							WHEN b.Change < -10 THEN 'Vekttap > 10% siste 180 dager (2p). '
							WHEN b.Change >= -10 AND
								b.Change < -5 THEN 'Vektendring > 5% siste 180 dager (1p). '
						END;

	-- Find no of weights
	MERGE
	INTO #temp a
	USING (SELECT ce.PersonId, COUNT(*) AS NoOfWeights
		FROM dbo.ClinEvent ce
		JOIN dbo.ClinDataPoint cdp
			ON cdp.EventId = ce.EventId AND cdp.ItemID = @WeightId AND cdp.Quantity
			> 0
		JOIN #temp t
			ON t.PersonId = ce.PersonId AND ce.EventTime < t.EventTime
		WHERE CONVERT(FLOAT, t.EventTime - ce.EventTime) < 180
		AND ce.StudyId = @StudyId
		GROUP BY ce.PersonId
		HAVING COUNT(*) < 2) b
	ON (a.PersonId = b.PersonId)
	WHEN MATCHED
		THEN UPDATE
			SET NoOfWeights = b.NoOfWeights;

	UPDATE #temp
	SET MustScore = 0, MsgText = 'Mindre enn 2 vektregistreringer siste 180 dager (0p). '
	WHERE NoOfWeights IS NOT NULL
	AND MustScore IS NULL;

	UPDATE #temp
	SET MustScore = 0, MsgText = 'Vektendring < 5% siste 180 dager (0p). '
	WHERE Weight > 1
	AND MustScore IS NULL;

	-- Add MustScore for BMI
	UPDATE #temp
	SET MustScore =
					CASE
						WHEN BMI < 18.5 THEN MustScore + 2
						WHEN BMI >= 18.5 AND
							BMI < 20 THEN MustScore + 1
					END,
	MsgText =
				CASE
					WHEN BMI < 18.5 THEN MsgText + ' BMI er under 18.5 (2p). '
					WHEN BMI >= 18.5 AND
						BMI < 20 THEN MsgText + ' BMI er under 20 (1p). '
					WHEN BMI >= 20 THEN MsgText + 'BMI er over 20 (' + dbo.GetShortNumber(ROUND(BMI, 1)) + ', 0p). '
				END
	WHERE BMI IS NOT NULL;

	MERGE
	INTO dbo.PersonAbstraction a
	USING (SELECT PersonId, MustScore, BMI, Weight, Height
		FROM #temp) b
	ON (a.PersonId = b.PersonId)
	WHEN MATCHED
		THEN UPDATE
			SET a.MustScore = b.MustScore, a.BMI = b.BMI, a.Weight = b.Weight, a.Height = b.Height
	WHEN NOT MATCHED
		THEN INSERT (PersonId, Height, Weight, MustScore, BMI)
				VALUES (b.PersonId, b.Height, b.Weight, b.MustScore, b.BMI);


	UPDATE #temp
	SET MsgHeader =
					CASE
						WHEN ISNULL(MustScore, -1) <= 0 THEN 'Ernæringstilstand'
						WHEN ISNULL(MustScore, -1) > 0 THEN 'OBS Ernæringstilstand'
						ELSE MsgHeader
					END,
	AlertFacet =
				CASE
					WHEN ISNULL(MustScore, -1) < 0 THEN 'DataMissing'
					WHEN ISNULL(MustScore, -1) = 0 THEN 'RiskLow'
					WHEN ISNULL(MustScore, -1) = 1 THEN 'RiskMedium'
					WHEN ISNULL(MustScore, -1) > 1 THEN 'RiskHigh'
					ELSE AlertFacet
				END,
	MsgText =
				CASE
					WHEN ISNULL(MustScore, -1) < 0 THEN 'Ernæringstilstand kan ikke overvåkes, fordi vekt og/eller høyde mangler. '
					WHEN ISNULL(MustScore, -1) = 1 THEN MsgText + 'MUST Score ' + CONVERT(VARCHAR, MustScore) + ' eller mer. Observasjon. '
					WHEN ISNULL(MustScore, -1) > 1 THEN MsgText + 'MUST Score ' + CONVERT(VARCHAR, MustScore) + ' eller mer. Start behandling. '
					ELSE MsgText
				END,
	AlertLevel =
				CASE
					WHEN ISNULL(MustScore, -1) > 3 THEN 3
					ELSE ISNULL(MustScore, 1)
				END;

	MERGE
	INTO dbo.Alert a
	USING (SELECT PersonId, AlertId, AlertLevel, AlertFacet, c.MsgHeader, c.MsgText
		FROM (SELECT t.PersonId, a.AlertId, t.AlertLevel, t.MsgHeader, t.AlertFacet, t.MsgText, RANK() OVER (PARTITION BY a.PersonId, a.StudyId ORDER BY a.AlertId DESC) AS rnk
			FROM dbo.Alert a
			JOIN #temp t
				ON t.PersonId = a.PersonId
			WHERE ISNULL(a.StudyId, 0) = ISNULL(@StudyId, 0)
			AND ISNULL(a.UserId, 0) = 0
			AND a.AlertClass = 'MUST') c
		WHERE c.rnk = 1) b
	ON (a.PersonId = b.PersonId
		AND a.AlertId = b.AlertId)
	WHEN MATCHED
		THEN UPDATE
			SET a.AlertLevel = b.AlertLevel,
			a.AlertHeader = b.MsgHeader,
			a.AlertMessage = b.MsgText,
			a.AlertButtons = 'TYM',
			a.AlertFacet = b.AlertFacet,
			a.HideUntil =
							CASE
								WHEN a.AlertFacet <> b.AlertFacet THEN NULL
								ELSE a.HideUntil
							END
	WHEN NOT MATCHED
		THEN INSERT (StudyId, PersonId, AlertLevel, AlertClass, AlertFacet, AlertHeader, AlertMessage, AlertButtons)
				VALUES (@StudyId, b.PersonId, b.AlertLevel, 'MUST', b.AlertFacet, b.MsgHeader, b.MsgText, 'TYM');
END
GO