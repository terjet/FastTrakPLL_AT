SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[MoveClinDataPoints] (@FromClinFormId INT, @ToClinFormId INT, @Message NVARCHAR(100) OUTPUT) AS
BEGIN
	DECLARE @ItemIds TABLE (
		ItemId INT
	);
	DECLARE @NoToMove INT = 0,
			@FromEventId INT = 0,
			@ToEventId INT = 0,
			@HasFromForm INT = 0,
			@HasToForm INT = 0,
			@FromRows INT = 0;

	-- Sjekk om skjemaene finnes 
	SELECT @HasFromForm = 1
	FROM dbo.ClinForm
	WHERE ClinFormId = @FromCLinFormId;
	SELECT @HasToForm = 1
	FROM dbo.ClinForm
	WHERE ClinFormId = @ToClinFormId;

	-- Begge skjemaene finnes, kan flytte 
	IF @HasFromForm > 0
		AND @HasToForm > 0
	BEGIN
		-- Finn data på fra-skjema 
		INSERT INTO @ItemIds
			SELECT cdp.ItemId
			FROM dbo.ClinDataPoint cdp
			JOIN dbo.MetaFormItem mfi ON mfi.ItemId = cdp.ItemId
			JOIN dbo.ClinForm cf ON cf.FormId = mfi.FormId AND cf.EventId = cdp.EventId
			WHERE cf.ClinFormId = @FromClinFormId;

		SELECT @FromRows = @@ROWCOUNT;

		-- Ekskluder alle som allerede finnes på til-skjema 
		DELETE it
			FROM @ItemIds it
			JOIN dbo.ClinDataPoint cdp
				ON cdp.ItemId = it.ItemId
			JOIN dbo.ClinForm cf
				ON cf.EventId = cdp.EventId
			JOIN dbo.MetaFormItem mfi
				ON mfi.FormId = cf.FormId
				AND mfi.ItemId = cdp.ItemId
				AND mfi.ItemId = it.itemid
		WHERE cf.ClinFormId = @ToClinFormId;

		-- Nå skal @ItemIds inneholde data som kan flyttes 
		SELECT @NoToMove = COUNT(*)
		FROM @ItemIds

		IF @NoToMove > 0
		BEGIN
			-- Finn EventId for skjemaene 
			SELECT @FromEventId = EventId
			FROM dbo.ClinForm
			WHERE ClinFormId = @FromClinFormId;
			SELECT @ToEventId = EventId
			FROM dbo.ClinForm
			WHERE ClinFormId = @ToClinFormId;

			-- Oppdaterer nå ClinDataPoint med til-eventid for de variabler som kan flyttes 
			UPDATE cdp
			SET cdp.EventId = @ToEventId
			FROM dbo.ClinDataPoint cdp
			JOIN @ItemIds items
				ON items.ItemId = cdp.ItemId
			JOIN dbo.ClinEvent ce
				ON ce.EventId = cdp.EventId
			WHERE cdp.EventId = @FromEventId;
		END

		SET @Message = '';
		IF @NoToMove < @FromRows
		BEGIN
			IF @NoToMove = 0
				SET @Message = 'Alle variablene finnes allerede hos mottaker, kan ikke overføre.'
			ELSE
				SET @Message = 'Noen av variablene finnes allerede hos mottaker.';
		END
	END
END
GO