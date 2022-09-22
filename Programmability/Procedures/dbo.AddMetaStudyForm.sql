SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddMetaStudyForm]( @StudyId INT, @FormId INT, @FormName varchar(24), @FormTitle varchar(128), @FormXML VARCHAR(MAX), @SurveyStatus VARCHAR(6) )
AS
BEGIN
  EXEC dbo.AddMetaForm @FormId, @FormName, @FormTitle, @FormXML, @SurveyStatus;
  IF NOT EXISTS( SELECT StudyFormId FROM dbo.MetaStudyForm WHERE FormId=@FormId AND StudyId=@StudyId )
    INSERT INTO dbo.MetaStudyForm (StudyId,FormId) VALUES (@StudyId,@FormId );
  UPDATE dbo.MetaStudyForm SET SurveyStatus=@SurveyStatus WHERE StudyId=@StudyId AND FormId=@FormId;
END
GO