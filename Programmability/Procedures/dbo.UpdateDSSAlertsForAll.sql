SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDSSAlertsForAll]( @StudyId INT)
AS
  DECLARE @PersonId INT;
BEGIN
  DECLARE studcase_cursor CURSOR FOR SELECT PersonId FROM StudCase WHERE StudyId=@StudyId;
  OPEN studcase_cursor;
  FETCH NEXT FROM studcase_cursor INTO @PersonId; 
  WHILE @@FETCH_STATUS = 0 BEGIN
    EXECUTE UpdateDSSAlerts @StudyId,@PersonId; 
    FETCH NEXT FROM studcase_cursor INTO @PersonId; 
  END    
  CLOSE studcase_cursor;
  DEALLOCATE studcase_cursor;
END
GO