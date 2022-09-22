SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NHN].[UpdateLivingStatusXML]( @NationalIds NVARCHAR(MAX), @XmlString NVARCHAR(MAX) ) AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @Xml XML;
		SELECT @Xml = CONVERT(XML, @XmlString);

		-- Convert xml to temp-table
		SELECT x.r.value('(NIN)[1]', 'nvarchar(100)') AS NationalId
			, x.r.value('(dateStatus)[1]', 'date') AS DeceasedDate
			, x.r.value('(regStatus)[1]', 'int') AS DeceasedInd
			, LEFT(x.r.value('(givenName)[1]', 'nvarchar(max)'), 30) AS FstName
			, LEFT(x.r.value('(middleName)[1]', 'nvarchar(max)'), 30) AS MidName
			, LEFT(x.r.value('(sn)[1]', 'nvarchar(max)'), 30) AS LstName
			, x.r.value('(postalCode)[1]', 'nvarchar(max)') AS PostalCode
			, x.r.value('(postalPlace)[1]', 'nvarchar(max)') AS City
			, x.r.value('(postalAddress)[1]', 'nvarchar(max)') AS StreetAddress
			, x.r.value('(st)[1]', 'nvarchar(max)') AS KommuneNr
			, x.r.value('(municipality)[1]', 'nvarchar(max)') AS KommuneNavn
			, x.r.value('(dateOfBirth)[1]', 'date') AS DOB INTO #temp
		FROM @Xml.nodes('/FRResponse/results/result') AS x (r);

		---- Update deceased persons
		MERGE
		INTO dbo.Person p USING (SELECT *
			FROM #temp
			WHERE DeceasedInd = 5) nhn
		ON (p.NationalId = nhn.NationalId)
		WHEN MATCHED
			THEN UPDATE
				SET p.DeceasedInd = 1, p.DeceasedDate = nhn.DeceasedDate;

		-- Check duplicates
		SELECT DISTINCT p.PersonId, t.NationalId, p.FstName, p.LstName, p.DOB
		INTO #duplicates
		FROM dbo.Person p
		JOIN #temp t ON t.FstName = p.FstName
			AND t.LstName = p.LstName
			AND t.DOB = p.DOB
			AND (t.NationalId != ISNULL(p.NationalId, ''));

		-- Add or update dbo.LivingStatusCheck with duplicated persons (cannot update these)
		MERGE
		INTO dbo.LivingStatusCheck lsc USING (SELECT * FROM #duplicates) p
		ON (lsc.NationalId = p.NationalId)
		WHEN MATCHED
			THEN UPDATE
				SET lsc.LastChecked = GETDATE()
				, lsc.CheckStatus = 0
				, lsc.CheckMessage = 'Duplikat: ' + p.FstName + '|' + p.LstName + '|' + CONVERT(VARCHAR, p.DOB,105)
		WHEN NOT MATCHED
			THEN INSERT (NationalId, LastChecked, CheckStatus, CheckMessage)
					VALUES (p.NationalId, GETDATE(), 0, 'Duplikat: ' + p.FstName + '|' + p.LstName + '|' + CONVERT(VARCHAR, p.DOB,105));

		-- Remove duplicates from temp
		DELETE FROM #temp
		WHERE NationalId IN (SELECT NationalId
				FROM #duplicates);

		-- Check missing from dbo.Person
		SELECT p.NationalId INTO #missing
		FROM dbo.Person p
		LEFT JOIN #temp t ON t.NationalId = p.NationalId
		WHERE CHARINDEX(p.NationalId, @NationalIds) > 1
		AND t.NationalId IS NULL;

		-- Add or update dbo.LivingStatusCheck with missing persons
		MERGE
		INTO dbo.LivingStatusCheck lsc USING (SELECT NationalId
			FROM #missing) p
		ON (lsc.NationalId = p.NationalId)
		WHEN MATCHED
			THEN UPDATE
				SET lsc.LastChecked = GETDATE()
				, lsc.CheckStatus = 0
				, lsc.CheckMessage = 'Ikke registrert i Folkeregisteret'
		WHEN NOT MATCHED
			THEN INSERT (NationalId, LastChecked, CheckStatus, CheckMessage)
					VALUES (p.NationalId, GETDATE(), 0, 'Ikke registrert i Folkeregisteret');

		-- Remove missing from temp
		DELETE FROM #temp
		WHERE NationalId IN (SELECT NationalId
				FROM #missing);

		-- Update living persons
		MERGE
		INTO dbo.Person p USING (SELECT *
			FROM #temp t
			WHERE t.DeceasedInd <> 5) nhn
		ON (p.NationalId = nhn.NationalId)
		WHEN MATCHED
			THEN UPDATE
				SET p.DeceasedInd = 0
				, p.FstName = Tools.CamelCaseIfChanged( p.FstName, RTRIM(CONCAT( nhn.FstName, ' ', nhn.MidName) ) )
				, p.MidName = NULL
				, p.LstName = Tools.CamelCaseIfChanged(p.LstName, nhn.LstName)
				, p.PostalCode = nhn.PostalCode
				, p.City = nhn.City
				, p.StreetAddress = nhn.StreetAddress
				, p.KommuneNr = nhn.KommuneNr
				, p.KommuneNavn = nhn.KommuneNavn;

		-- Add or update dbo.LivingStatusCheck with checked persons
		MERGE
		INTO dbo.LivingStatusCheck lsc USING (SELECT NationalId
			FROM #temp) p
		ON (lsc.NationalId = p.NationalId)
		WHEN MATCHED
			THEN UPDATE
				SET lsc.LastChecked = GETDATE()
				, lsc.CheckStatus = 1
				, lsc.CheckMessage = 'Oppdatert med data fra Folkeregisteret'
		WHEN NOT MATCHED
			THEN INSERT (NationalId, LastChecked, CheckStatus, CheckMessage)
					VALUES (p.NationalId, GETDATE(), 1, 'Oppdatert med data fra Folkeregisteret');
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(MAX),
				@ErrorSeverity INT,
				@ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5))
			, @ErrorSeverity = ERROR_SEVERITY()
			, @ErrorState = ERROR_STATE();
		ROLLBACK TRANSACTION;
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH;
END;
GO

GRANT EXECUTE ON [NHN].[UpdateLivingStatusXML] TO [ScheduledTask]
GO