SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListSnarligLegevurdering] (@StudyId INT) AS
BEGIN
    SELECT v.*, cdp2.EnumVal, cdp1.EnumVal AS HasteGradEnumVal, mia2.OptionText, CONCAT('Hastegrad: ', ISNULL(mia1.OptionText, '(ubesvart)'), ', Skjemadato: ', FORMAT(cf.CreatedAt, 'dd.MM.yyyy')) AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    JOIN dbo.ClinEvent ce ON ce.PersonId = v.PersonId
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GBD_Legevurdering'
    JOIN dbo.ClinDataPoint cdp1 ON cdp1.EventId = ce.EventId AND cdp1.ItemId = 2537
    JOIN dbo.MetaItemAnswer mia1 ON mia1.ItemId = cdp1.ItemId AND mia1.OrderNumber = cdp1.EnumVal
    LEFT JOIN dbo.ClinDataPoint cdp2 ON cdp2.EventId = ce.EventId AND cdp2.ItemId = 2533
    LEFT JOIN dbo.MetaItemAnswer mia2 ON mia2.ItemId = cdp2.ItemId AND mia2.OrderNumber = cdp2.EnumVal
    WHERE v.StudyId = @StudyId
    AND ISNULL(cdp2.EnumVal, -1) IN (-1, 3)
    AND cdp1.EnumVal IN (2, 3)
    ORDER BY v.PersonId;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListSnarligLegevurdering] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListSnarligLegevurdering] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListSnarligLegevurdering] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListSnarligLegevurdering] TO [Vernepleier]
GO