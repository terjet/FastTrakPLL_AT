SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListLegevisitt] ( @StudyId INT ) AS
BEGIN
    SELECT v.*, cdp1.EnumVal, mia1.OrderNumber, CONCAT( 'Hastegrad: ', ISNULL( mia2.OptionText, '(ubesvart)'), ', Skjemadato: ', FORMAT(cf.CreatedAt, 'dd.MM.yyyy')) AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    JOIN dbo.ClinEvent ce ON ce.PersonId = v.PersonId
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GBD_Legevurdering'
    LEFT JOIN dbo.ClinDataPoint cdp1 ON cdp1.EventId = ce.EventId AND cdp1.ItemId = 2533 
    LEFT JOIN dbo.MetaItemAnswer mia1 ON mia1.ItemId = cdp1.ItemId AND mia1.OrderNumber = cdp1.EnumVal
    LEFT JOIN dbo.ClinDataPoint cdp2 ON cdp2.EventId = ce.EventId AND cdp2.ItemId = 2537 
    LEFT JOIN dbo.MetaItemAnswer mia2 ON mia2.ItemId = cdp2.ItemId AND mia2.OrderNumber = cdp2.EnumVal
    WHERE v.StudyId = @StudyId
    AND ISNULL( cdp1.EnumVal, -1 ) IN ( -1, 3 )
    ORDER BY v.PersonId;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListLegevisitt] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListLegevisitt] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListLegevisitt] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListLegevisitt] TO [Vernepleier]
GO