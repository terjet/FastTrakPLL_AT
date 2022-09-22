SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[DeleteAllClinicalData]( @PersonId INT, @DOB DATETIME, @ReasonText VARCHAR(MAX) ) AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  IF NOT EXISTS (SELECT 1
      FROM dbo.Person
      WHERE PersonId = @PersonId
      AND DOB = @DOB)
  BEGIN
    RAISERROR ('Finner ingen personer som matcher både PersonId og fødselsdato. Sletting kan ikke utføres.', 16, 1);
    RETURN -1;
  END;

  BEGIN TRANSACTION;

  PRINT ' -- Delete labdata and alerts.';
  DELETE FROM dbo.LabData WHERE PersonId = @PersonId;
  DELETE FROM dbo.LabDataDeleted WHERE PersonId = @PersonId;
  DELETE FROM dbo.DSSRuleExecute WHERE PersonId = @PersonId;

  PRINT ' -- Delete all drug data.';
  DELETE FROM dbo.DrugPause WHERE TreatId IN (SELECT TreatId FROM dbo.DrugTreatment WHERE PersonId = @PersonId);
  DELETE FROM dbo.DrugDosing WHERE TreatId IN (SELECT TreatId FROM dbo.DrugTreatment WHERE PersonId = @PersonId);
  DELETE FROM dbo.DrugPrescription WHERE TreatId IN (SELECT TreatId FROM dbo.DrugTreatment WHERE PersonId = @PersonId);
  DELETE FROM dbo.DrugTreatment WHERE PersonId = @PersonId; 

  PRINT ' -- Delete all diagnose data.';
  DELETE FROM dbo.ClinProblem WHERE PersonId = @PersonId;

  PRINT ' -- Delete clinical datapoints as well as their deletion history.';
  DELETE FROM dbo.ClinDataPointLog WHERE RowId IN (SELECT RowId FROM dbo.ClinDataPoint cdp JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId WHERE ce.PersonId = @PersonId);
  DELETE FROM dbo.ClinDataPointDeleted WHERE EventId IN (SELECT EventId FROM dbo.ClinEvent WHERE PersonId = @PersonId);
  DISABLE TRIGGER T_ClinDataPoint_Update ON dbo.ClinDataPoint;
  DELETE FROM dbo.ClinDataPoint WHERE EventId IN (SELECT EventId FROM dbo.ClinEvent WHERE PersonId = @PersonId);
  ENABLE TRIGGER T_ClinDataPoint_Update ON dbo.ClinDataPoint;

  PRINT ' -- Delete Patient reported outcome measures.';
  DELETE FROM PROM.FormOrder WHERE PersonId = @PersonId;

  PRINT ' -- Delete data from infection tracing module.';
  DELETE FROM Pandemic.Contact WHERE ContactPersonId = @PersonId or IndexPersonId = @PersonId;

  PRINT ' -- Delete clinical forms/events as well as change history.';
  DELETE FROM dbo.ClinFormLog WHERE ClinFormId IN (SELECT ClinFormId FROM dbo.ClinForm cf JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId WHERE ce.PersonId = @PersonId);
  DELETE FROM dbo.ClinForm WHERE EventId IN (SELECT EventId FROM dbo.ClinEvent WHERE PersonId = @PersonId);
  DELETE FROM dbo.ClinTouch WHERE EventId IN (SELECT EventId FROM dbo.ClinEvent WHERE PersonId = @PersonId);
  DELETE FROM dbo.ClinEvent WHERE PersonId = @PersonId;

  PRINT ' -- Delete patient from all clinical studies.';
  DELETE FROM dbo.StudCase WHERE PersonId = @PersonId;

  PRINT ' -- Delete Audit information related to patient.';
  DELETE FROM AuditLog.CaseAccess WHERE PersonId = @PersonId;
  DELETE FROM AccessCtrl.UserCaseBlock WHERE PersonId = @PersonId;
  DELETE FROM dbo.ClinRelation WHERE PersonId = @PersonId;
  DELETE FROM dbo.CaseLog WHERE PersonId = @PersonId;
  DELETE FROM dbo.DSSRuleError WHERE PersonId = @PersonId;

  PRINT ' -- Finally delete person (keep if the person is also a user).';
  IF NOT EXISTS (SELECT PersonId FROM dbo.UserList WHERE PersonId = @PersonId) 
  BEGIN
	 DELETE FROM dbo.PersonDocumentLog WHERE PersonId = @PersonId;
	 DELETE FROM dbo.PersonLog WHERE PersonId = @PersonId;
     DELETE FROM dbo.Person WHERE PersonId = @PersonId;
  END;

  PRINT ' -- Log the deletion and the reason for it.';
  INSERT INTO dbo.ClinicalDataDeletion (PersonId, ReasonText) VALUES (@PersonId, @ReasonText);

  IF @@TRANCOUNT > 0 COMMIT TRANSACTION;
END
GO