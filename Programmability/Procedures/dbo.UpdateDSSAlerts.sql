SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDSSAlerts]( @StudyId INT, @PersonId INT )
AS
BEGIN
  DECLARE @RuleProc nvarchar(128);
  DECLARE @StartTime DateTime;
  DECLARE @CallTime DateTime;
  DECLARE @StudyRuleId INT;
  UPDATE StudCase SET LastRuleExecute=GetDate() WHERE StudyId=@StudyId AND PersonId=@PersonId;
  SET @CallTime = GetDate();
  DECLARE rule_list CURSOR FOR
    SELECT sr.StudyRuleId,RuleProc FROM DSSRule r
     JOIN DSSStudyRule sr ON sr.RuleId=r.RuleId
     JOIN Study s ON s.StudyName=sr.StudyName
     WHERE s.StudyId=@StudyId AND sr.RuleActive=1;
  OPEN rule_list;
  FETCH NEXT FROM rule_list INTO @StudyRuleId,@RuleProc
  WHILE @@FETCH_STATUS = 0 BEGIN
    SET @StartTime = GetDate();       
    BEGIN TRY
    EXEC @RuleProc @StudyId,@PersonId;
    INSERT INTO DSSRuleExecute (PersonId,StudyRuleId,MsElapsed)
      VALUES (@PersonId,@StudyRuleId,DATEDIFF(ms,@StartTime,GetDate()) )
    END TRY
    BEGIN CATCH  
      INSERT INTO dbo.DSSRuleError (StudyId,PersonId,RuleProc,ErrorNumber,ErrorSeverity,ErrorLine,ErrorMessage) 
      VALUES (@StudyId,@PersonId,@RuleProc,ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_LINE(),ERROR_MESSAGE())
    END CATCH
    FETCH NEXT FROM rule_list INTO @StudyRuleId,@RuleProc;
  END;
  CLOSE rule_list;
  DEALLOCATE rule_list;
END
GO

GRANT EXECUTE ON [dbo].[UpdateDSSAlerts] TO [FastTrak]
GO