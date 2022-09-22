SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[MetaFormIsUsable]( @FormId INT )
RETURNS TINYINT AS
BEGIN
  DECLARE @RetVal TINYINT;
  -- Only superusers, pilotusers and db_owners can use forms that are in test mode.
  IF EXISTS (SELECT
        FormId
      FROM dbo.MetaForm
      WHERE FormId = @FormId
      AND ((SurveyStatus = 'Open')
      OR (SurveyStatus IN ('Open', 'Test')
      AND (IS_MEMBER('db_owner') + IS_MEMBER('superuser') + IS_MEMBER('pilotuser') > 0))))
    SET @RetVal = 1
  ELSE
    SET @RetVal = 0;
  RETURN @RetVal;
END
GO