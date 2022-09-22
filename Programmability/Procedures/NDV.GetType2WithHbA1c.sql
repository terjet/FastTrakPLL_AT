SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetType2WithHbA1c]( @StudyId INT ) AS
BEGIN
  -- Create temporary table
  SELECT p.PersonId,p.DOB,p.FullName,p.GroupName,dbo.GetLastValue(PersonId,'HBA1C') AS HbA1c INTO #temp
  FROM NDV.Type2 p;
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,'HbA1c = ' + CONVERT(VARCHAR,HbA1c) as InfoText 
  FROM #temp 
  ORDER BY HbA1c DESC
END
GO

GRANT EXECUTE ON [NDV].[GetType2WithHbA1c] TO [FastTrak]
GO