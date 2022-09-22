SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnDSSRulesAreDirty]( @StudyId INT, @PersonId INT ) RETURNS INT AS
BEGIN
  DECLARE @RuleLag FLOAT;
  DECLARE @RetVal INT;
  DECLARE @LastWrite DATETIME;
  SELECT @RuleLag = RuleLag, @LastWrite = LastWrite FROM dbo.StudCase WHERE StudyId=@StudyId AND PersonId=@PersonId;
  -- Some rules need to be triggered as time moves on, even if there is no new data.
  IF ( @RuleLag IS NULL ) OR ( @RuleLag > 0 ) OR ( DATEDIFF ( DAY, @LastWrite ,GETDATE() ) > 1 ) 
    SET @RetVal = 1
  ELSE
    SET @RetVal = 0;
  RETURN @RetVal;
END
GO