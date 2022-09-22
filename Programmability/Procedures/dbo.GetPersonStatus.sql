SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPersonStatus]( @StudyId INT, @PersonId INT )
AS
BEGIN
  SELECT 
      sc.FinState,sc.GroupId,sc.Investor,sc.StudyId,
      sg.GroupName,ss.StatusText,ss.StatusActive,
      c.*,mr.* 
    FROM dbo.StudCase sc
    LEFT OUTER JOIN StudyStatus ss ON ss.StudyId=@StudyId AND ss.StatusId=sc.FinState
    LEFT OUTER JOIN StudyGroup sg ON sg.StudyId=@StudyId AND sg.GroupId=sc.GroupId 
    LEFT OUTER JOIN StudyCenter c ON c.CenterId=sg.CenterId
    LEFT OUTER JOIN ClinRelation cr ON cr.PersonId=sc.PersonId AND cr.UserId=USER_ID() AND ExpiresAt>getdate()
    LEFT OUTER JOIN MetaRelation mr ON mr.RelId = cr.RelId 
  WHERE sc.StudyId=@StudyId AND sc.PersonId=@PersonId
END
GO