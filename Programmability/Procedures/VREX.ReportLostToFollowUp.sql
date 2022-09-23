SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [VREX].[ReportLostToFollowUp]( @StudyId INT ) AS
BEGIN
  SELECT DATEDIFF(DD, LastRegistered, GETDATE()) AS DaysSinceLastReg, Registrations.* FROM 
    (
    SELECT v.*, inclusion.EventTime AS 'Inclusion', oneYear.EventTime AS 'OneYear', twoYears.EventTime AS 'TwoYears',
      threeYears.EventTime AS 'ThreeYears', fourYears.EventTime AS 'FourYears', COALESCE(fourYears.EventTime, threeYears.EventTime, twoYears.EventTime, oneYear.EventTime, inclusion.EventTime) AS LastRegistered
    FROM dbo.ViewActiveCaseListStub v 
    LEFT JOIN dbo.GetLastDateTable(9784, NULL) inclusion ON v.PersonId = inclusion.PersonId
    LEFT JOIN dbo.GetLastDateTable(9788, NULL) oneYear ON v.PersonId = oneYear.PersonId
    LEFT JOIN dbo.GetLastDateTable(9789, NULL) twoYears ON v.PersonId = twoYears.PersonId
    LEFT JOIN dbo.GetLastDateTable(9790, NULL) threeYears ON v.PersonId = threeYears.PersonId
    LEFT JOIN dbo.GetLastDateTable(9791, NULL) fourYears ON v.PersonId = fourYears.PersonId
    WHERE v.StudyId = @StudyId AND fourYears.EventTime IS NULL 
    ) Registrations
  WHERE LastRegistered IS NOT NULL AND DATEDIFF(DD, LastRegistered, GETDATE()) > 365
  ORDER BY DaysSinceLastReg DESC;
END
GO

GRANT EXECUTE ON [VREX].[ReportLostToFollowUp] TO [FastTrak]
GO