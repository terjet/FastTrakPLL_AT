SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNewForms]( @StudyId INT, @DaysBack float, @UserId INT = NULL ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,sg.GroupName,cf.CreatedAt,mf.FormTitle + ' / ' + dbo.ShortTime(ce.EventTime) + ' ' + ISNULL(p.Signature, '?' ) As InfoText
  FROM ViewActiveCaseListStub v
    JOIN ClinEvent ce on ce.PersonId=v.PersonId
    JOIN StudCase sc on sc.PersonId=v.PersonId AND sc.StudyId=v.StudyId
    JOIN StudyGroup sg on sg.GroupId=sc.GroupId AND sg.StudyId=v.StudyId
    JOIN ClinForm cf on cf.EventId=ce.EventId AND cf.DeletedBy IS NULL AND ( cf.CreatedBy=@UserId OR @UserId IS NULL ) 
    JOIN MetaForm mf on mf.FormId=cf.FormId
    JOIN UserList ul ON ul.UserId=cf.CreatedBy
     LEFT OUTER JOIN Person p ON p.PersonId=ul.PersonId
    WHERE ce.EventTime > getdate()-@DaysBack AND v.StudyId=@StudyId
    ORDER BY ce.EventTime DESC
END
GO