SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPersonDetails]( @SessId INT, @PersonId INT ) AS
BEGIN
  DECLARE @StudyId INT;
  SET @StudyId = dbo.GetStudyId( @SessId );
  IF NOT @StudyId IS NULL BEGIN
    SELECT p.*,sc.GroupId,sc.FinState FROM Person p
      LEFT OUTER JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId AND sc.StudyId=@StudyId
    WHERE p.PersonId=@PersonId;
  END;
END
GO