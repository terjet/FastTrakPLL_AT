SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MapByNationalId] ( @NationalId VARCHAR(16) )
AS
BEGIN
  SET NOCOUNT ON;    
  DECLARE @PersonId INT;
  DECLARE @MatchCount INT;
  SELECT @MatchCount = COUNT(*) FROM Person WHERE NationalId=@NationalId;
  IF @MatchCount <> 1
    SELECT @PersonId = -@MatchCount
  ELSE 
    SELECT @PersonId = PersonId FROM Person WHERE NationalId=@NationalId;
  SELECT @PersonId AS PersonId;
END;
GO