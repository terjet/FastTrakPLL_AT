SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[UpdateEmployeeData] ( @EmployeeNumber INT, @JobTitle VARCHAR(32), @AddressLine1 VARCHAR(64), @AddressLine2 VARCHAR(64), @HomePostalCode VARCHAR(8), @HomeCity VARCHAR(32), @SupervisorEmployeeNumber INT, @WorkDepartment VARCHAR(32) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Person
  SET JobTitle = @JobTitle, AddressLine1 = @AddressLine1, AddressLine2 = @AddressLine2, HomePostalCode = @HomePostalCode, HomeCity = @HomeCity, 
    SupervisorEmployeeNumber = @SupervisorEmployeeNumber, WorkDepartment = @WorkDepartment
  WHERE EmployeeNumber = @EmployeeNumber;
END
GO