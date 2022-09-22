SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetNonPumpWithHighHbA1c]( @StudyId INT, @AgeMin FLOAT, @AgeMax FLOAT, @HbA1cCutoff FLOAT ) AS
BEGIN
  -- Create temporary table
  SELECT p.PersonId,p.DOB,p.FullName,p.GroupName,dbo.GetLastValue(PersonId,'HBA1C') AS HbA1c INTO #temp
  FROM NDV.Type1NotInsulinPump p WHERE p.Age >= @AgeMin AND p.Age < @AgeMax;
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,'HbA1c = ' + CONVERT(VARCHAR,HbA1c) as InfoText 
  FROM #temp WHERE HbA1c >= @HbA1cCutoff
  ORDER BY HbA1c DESC
END
GO