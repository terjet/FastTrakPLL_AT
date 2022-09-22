SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddStudCase]( @StudyId INT, @PersonId INT ) AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @Journalansvarlig INT = NULL;
 IF ( IS_MEMBER('Journalansvarlig') + IS_MEMBER('db_owner') ) > 0 SET @Journalansvarlig = USER_ID();
 IF NOT EXISTS( SELECT StudCaseId FROM dbo.StudCase
 WHERE StudyId=@StudyId AND PersonId=@PersonId )
   INSERT INTO dbo.StudCase (StudyId,PersonId,FinState,Journalansvarlig)
   VALUES( @StudyId,@PersonId,1,@Journalansvarlig);
END
GO