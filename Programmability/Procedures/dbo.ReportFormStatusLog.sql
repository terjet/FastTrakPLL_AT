SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportFormStatusLog]( @ClinFormId INT )
AS
BEGIN 
  SELECT ClinFormId,cl.CreatedAt,cl.Comment,p.FullName,ISNULL(mfs.StatusDesc,'(unknown)') AS StatusDesc                                                                                   
  FROM dbo.ClinFormLog cl
  LEFT OUTER JOIN dbo.UserList ul ON ul.UserId=cl.CreatedBy
  LEFT OUTER JOIN dbo.Person p ON p.PersonId=ul.PersonId
  LEFT OUTER JOIN dbo.MetaFormStatus mfs ON mfs.FormStatus=cl.FormStatus
  WHERE ClinFormId=@ClinFormId                    
  ORDER BY ClinFormLogId DESC 
END
GO

GRANT EXECUTE ON [dbo].[ReportFormStatusLog] TO [FastTrak]
GO