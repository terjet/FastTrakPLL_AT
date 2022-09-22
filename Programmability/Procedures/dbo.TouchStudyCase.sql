SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TouchStudyCase]( @StudyId INT, @PersonId INT ) AS
BEGIN
  UPDATE StudCase SET LastWrite = getdate() WHERE StudyId = @StudyId AND PersonId=@PersonId;
END
GO

GRANT EXECUTE ON [dbo].[TouchStudyCase] TO [FastTrak]
GO