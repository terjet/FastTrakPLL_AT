SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RuleDrugToProblem]( @StudyId INT, @PersonId INT ) AS
  DECLARE @DrugName VARCHAR(64);
  DECLARE @ATC VARCHAR(7);
  DECLARE @ListId INT;
  DECLARE @ListName VARCHAR(32);
  DECLARE @DrugProbId INT;
  DECLARE @ItemCode VARCHAR(8);
  DECLARE @ProbDesc VARCHAR(32);
  DECLARE @ProbStatus INT;
  DECLARE @AlertClass varchar(12);
  DECLARE @AlertHeader varchar(64);
  DECLARE @AlertMsg varchar(512);
  DECLARE @AlertLevel INT;
  DECLARE @AlertFacet varchar(16);
BEGIN
  /* Disable all old alerts for this rule */
  UPDATE Alert SET AlertLevel=0 WHERE StudyId=@StudyId AND PersonId=@PersonId AND AlertClass LIKE 'DrugProb#%';
  /* Create list of problem matches for the patient's' drugs */
  DECLARE alert_list CURSOR FOR
    SELECT mdp.DrugProbId,mdp.ATC,dt.DrugName,mnl.ListId,mnl.ListName,mdp.ItemCode,mdp.ProbDesc,
      dbo.GetProblemStatus(dt.PersonId,mnl.ListId,mdp.ItemCode) AS ProbStatus
    FROM DrugTreatment dt
      JOIN dbo.KBDrugToProblem mdp ON CHARINDEX(mdp.ATC,dt.ATC) = 1
      JOIN dbo.MetaNomList mnl ON mnl.ListName=mdp.ListName AND ListActive=1
    WHERE ( dt.PersonId=@PersonId );
  /* Walk through the list, adding a rule for each one with status = 0 */
  OPEN alert_list;
  FETCH NEXT FROM alert_list INTO @DrugProbId,@ATC,@DrugName,@ListId,@ListName,@ItemCode,@ProbDesc,@ProbStatus;
  WHILE @@FETCH_STATUS = 0 BEGIN
    /* Prepare alert data */
    SET @AlertClass = 'DrugProb#' + CONVERT(VARCHAR,@DrugProbId);
    SET @AlertHeader = @ProbDesc;
    IF @ProbStatus=0 BEGIN
       SET @AlertHeader = @AlertHeader + '?';
       SET @AlertLevel = 3
       SET @AlertFacet = 'DataMissing';
    END
    ELSE BEGIN
      SET @AlertLevel = 0;
      SET @AlertFacet = 'DataFound';
    END
    SELECT @ListId = dbo.GetListId( @ListName );
    SET @AlertMsg = dbo.GetTextItem( 'DrugToProblem',@AlertFacet );
    /* Do replacements */
    IF CHARINDEX('@DrugName',@AlertMsg) > 0
      SET @AlertMsg = REPLACE( @AlertMsg,'@DrugName',@DrugName );
    IF CHARINDEX('@ProbDesc',@AlertMsg) > 0
      SET @AlertMsg = REPLACE( @AlertMsg,'@ProbDesc',@ProbDesc );
    IF CHARINDEX('@ListId',@AlertMsg) > 0
      SET @AlertMsg = REPLACE( @AlertMsg,'@ListId',@ListId );
    IF CHARINDEX('@ItemCode',@AlertMsg) > 0
      SET @AlertMsg = REPLACE( @AlertMsg,'@ItemCode',@ItemCode );
    EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,@AlertClass,@AlertFacet,@AlertHeader,@AlertMsg,'MY';
    FETCH NEXT FROM alert_list INTO @DrugProbId,@ATC,@DrugName,@ListId,@ListName,@ItemCode,@ProbDesc,@ProbStatus;
  END;
  CLOSE alert_list;
  DEALLOCATE alert_list;
END;
GO

GRANT EXECUTE ON [dbo].[RuleDrugToProblem] TO [FastTrak]
GO