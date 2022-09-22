SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MapByDobName] ( @DOB DateTime, @FstName VARCHAR(30), @LstName VARCHAR(30) )
AS
BEGIN
  SET NOCOUNT ON;    
  DECLARE @PersonId INT;
  DECLARE @MatchCount INT;
  SELECT @MatchCount = COUNT(*) FROM Person WHERE DOB=@DOB AND FstName=@FstName AND LstName=@LstName;
  IF @MatchCount <> 1
    SET @PersonId = -@MatchCount
  ELSE 
    SELECT @PersonId = PersonId FROM Person WHERE DOB=@DOB AND FstName=@FstName AND LstName=@LstName;
  SELECT @PersonId AS PersonId;
END;
GO