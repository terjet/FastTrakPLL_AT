SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[MergeEmployeeDuplicate]( @TargetPersonId INT, @DuplicatePersonId INT ) AS
BEGIN
 
  SET NOCOUNT ON;     
  SET XACT_ABORT ON;
  
  -- Make sure that the duplicate doesn't have any data that will be orphaned.
  
  IF EXISTS (SELECT 1 FROM dbo.ClinEvent WHERE PersonId = @DuplicatePersonId)
  OR EXISTS (SELECT 1 FROM dbo.ClinProblem WHERE PersonId = @DuplicatePersonId)
  OR EXISTS (SELECT 1 FROM dbo.UserList WHERE PersonId = @DuplicatePersonId)
  BEGIN
    RAISERROR( 'Kan ikke markere PID = %d som duplikat fordi han/hun har kliniske data og/eller er systembruker.', 16, 1, @DuplicatePersonId );
    RETURN -1;
  END;

  BEGIN TRY           
  
    BEGIN TRANSACTION;
    
    MERGE dbo.Person trg USING 
      ( 
        SELECT s.* 
        FROM dbo.Person s 
        JOIN dbo.Person t ON t.DOB = s.DOB
        WHERE s.PersonId = @DuplicatePersonId AND s.EmployeeNumber > 0 
          AND t.EmployeeNumber IS NULL AND t.PersonId = @TargetPersonId 
      ) src
      ON (trg.PersonId = @TargetPersonId)
      WHEN MATCHED
        THEN UPDATE SET
          trg.GSM = src.GSM,    
          trg.UserName = CONCAT( '*', src.UserName ),
          trg.HPRNo = -src.HPRNo,                    
          trg.EmployeeNumber = -src.EmployeeNumber,
          trg.EmailAddress = src.EmailAddress,
          trg.AddressLine1 = src.AddressLine1,
          trg.AddressLine2 = src.AddressLine2,
          trg.HomePostalCode = src.HomePostalCode,
          trg.HomeCity = src.HomeCity,
          trg.JobTitle = src.JobTitle,
          trg.SupervisorEmployeeNumber = src.SupervisorEmployeeNumber,
          trg.WorkDepartment = src.WorkDepartment;

    -- Expected 1 row to be updated at this point.
          
    IF @@ROWCOUNT <> 1 
      RAISERROR(  'Kilde eller mål finnes ikke, de har ulike fødselsdatoer, evt. PID = %d mangler ansattnummer og PID = %d har dette.', 16, 1, @DuplicatePersonId, @TargetPersonId );
    
    -- Clear data on the original person
    
    UPDATE dbo.Person SET 
      FstName='Duplikat', MidName = NULL, LstName = @TargetPersonId, HPRNo = NULL, EmployeeNumber = NULL, UserName = NULL,
      EmailAddress = NULL, SupervisorEmployeeNumber = NULL, AddressLine1 = NULL, AddressLine2 = NULL, HomePostalCode = NULL,
      HomeCity = NULL,JobTitle = NULL, WorkDepartment = NULL
    WHERE PersonId = @DuplicatePersonId;

    -- Update fields that have unique indices after data has been copied
        
    UPDATE dbo.Person SET EmployeeNumber = -EmployeeNumber, HPRNo = -HPRNo, UserName = NULLIF(REPLACE( UserName, '*', '' ),'') 
    WHERE PersonId = @TargetPersonId AND EmployeeNumber < 0;
    
    -- Update Pandemic

    UPDATE Pandemic.Contact SET IndexPersonId = @TargetPersonId WHERE IndexPersonId = @DuplicatePersonId;
    UPDATE Pandemic.Contact SET ContactPersonId = @TargetPersonId WHERE ContactPersonId = @DuplicatePersonId;

    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;   
    
    PRINT CONCAT('Informasjon fra ', @DuplicatePersonId,' er flyttet til ', @TargetPersonId, ', og førstnevnte er markert som et duplikat.' );
     
  END TRY
  
  BEGIN CATCH
    PRINT ERROR_MESSAGE();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
  END CATCH;
  
END
GO

GRANT EXECUTE ON [Tools].[MergeEmployeeDuplicate] TO [Administrator]
GO