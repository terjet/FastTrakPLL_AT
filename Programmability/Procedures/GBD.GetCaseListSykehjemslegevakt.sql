SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListSykehjemslegevakt] (@StudyId INT) AS
BEGIN
    SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, p.GenderId, sg.GroupName, ss.StatusText, cdpt2.EnumVal, cdp1.EnumVal, CONCAT('Institusjon: ', sct.CenterName, ', Skjemadato: ', FORMAT(cf.CreatedAt, 'dd.MM.yyyy')) AS InfoText
    FROM dbo.Person p
    JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId AND sc.StudyId = @StudyId
    JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState AND ss.StatusActive = 1
    JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId AND sg.GroupActive = 1
    JOIN dbo.StudyCenter sct ON sct.CenterId = sg.CenterId
    JOIN dbo.ClinEvent ce ON ce.PersonId = p.PersonId AND ce.StudyId = @StudyId
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
    JOIN dbo.MetaForm mf ON mf.FormName = 'GBD_Legevurdering'
    JOIN dbo.ClinDataPoint cdp1 ON cdp1.EventId = ce.EventId AND cdp1.ItemId = 2537
    JOIN dbo.MetaItemAnswer mia1 ON mia1.ItemId = cdp1.ItemId AND mia1.OrderNumber = cdp1.EnumVal
    LEFT JOIN dbo.ClinDataPoint cdpt2 ON cdpt2.EventId = ce.EventId AND cdpt2.ItemId = 2533
    LEFT JOIN dbo.MetaItemAnswer mia2 ON mia2.ItemId = cdpt2.ItemId AND mia2.OrderNumber = cdpt2.EnumVal
    WHERE ISNULL(cdpt2.EnumVal, -1) IN (-1, 3)
    AND cdp1.EnumVal = 3
    ORDER BY p.PersonId;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListSykehjemslegevakt] TO [Lege]
GO