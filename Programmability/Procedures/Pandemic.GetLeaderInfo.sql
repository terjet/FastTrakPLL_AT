SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[GetLeaderInfo]( @PersonId INT ) AS
BEGIN
  -- Used in Covid-19Patient.html
  SELECT 
    p.JobTitle, 
    p.WorkDepartment,
    lp.PersonId, 
    lp.WorkDepartment as SupervisorWorkDepartment, 
    lp.JobTitle as SupervisorJobTitle, 
    lp.FullName as SupervisorFullName, 
    lp.GSM as SupervisorPhoneNumber, 
    lp.EmailAddress as SupervisorEmailAddress
  FROM dbo.Person p 
  JOIN dbo.Person lp ON lp.EmployeeNumber = p.SupervisorEmployeeNumber
  WHERE p.PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [Pandemic].[GetLeaderInfo] TO [FastTrak]
GO