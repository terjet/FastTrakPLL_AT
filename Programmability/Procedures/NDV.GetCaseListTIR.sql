SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListTIR]( @StudyId INT ) AS 
BEGIN
  SELECT v.*, 
    CONCAT('TIR = ', CONVERT(varchar(3), FLOOR(timeInRange.Quantity)), ' % (', FORMAT(timeInRange.EventTime, 'dd.MM.yyyy'), ')') AS InfoText 
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastQuantityTable( 3849, NULL ) timeInRange ON timeInRange.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY timeInRange.Quantity, v.FullName;
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListTIR] TO [FastTrak]
GO