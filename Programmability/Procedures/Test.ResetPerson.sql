SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Test].[ResetPerson]( @PersonId INT, @LogId INT ) AS
BEGIN
  SET NOCOUNT ON;
  MERGE dbo.Person AS trg
  USING ( SELECT * FROM dbo.PersonLog WHERE LogId = @LogId AND PersonId = @PersonId ) AS src
  ON trg.PersonId = src.PersonId
  WHEN MATCHED THEN
    UPDATE SET trg.FstName = src.FstName, trg.LstName = src.LstName;
END
GO