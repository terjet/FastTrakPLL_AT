SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FEST].[GetMatchingDrugsForPerson]( @SearchText VARCHAR(32), @PersonId INT = 0)AS
BEGIN
    SET @SearchText = @SearchText + '%';
    SELECT DISTINCT
        PIA.ATC
       ,PIA.DrugName
       ,NULL AS DrugForm
       ,NULL AS StartReason
       ,NULL AS DoseCode
       ,NULL AS StrengthUnit
       ,NULL AS Strength
       ,ISNULL(dt.PersonId, 0) PersonId
    FROM dbo.PIA
    LEFT JOIN dbo.DrugTreatment dt
        ON dt.PersonId = @PersonId
            AND dt.ATC = PIA.ATC
    WHERE ((PIA.SubstanceName LIKE @SearchText)
    OR (PIA.DrugName LIKE @SearchText)
    OR (PIA.ATC LIKE @SearchText))
    ORDER BY ISNULL(dt.PersonId, 0) DESC, PIA.DrugName;
END
GO