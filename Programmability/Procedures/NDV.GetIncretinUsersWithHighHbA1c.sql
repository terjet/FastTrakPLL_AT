SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetIncretinUsersWithHighHbA1c]( @StudyId INT, @AgeMin FLOAT, @AgeMax FLOAT, @HbA1cCutoff FLOAT ) AS
BEGIN
  -- Create temporary table
  SELECT PersonId,DOB,FullName,GroupName,dbo.GetLastLab(PersonId,'HBA1C_MMOL') AS HbA1c 
  INTO #temp
  FROM NDV.IncretinUsers WHERE ( Age >= @AgeMin ) AND ( Age < @AgeMax );
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,'HbA1c = ' + SUBSTRING(CONVERT(VARCHAR,HbA1c),1,4) AS InfoText 
  FROM #temp WHERE HbA1c >= @HbA1cCutoff
  ORDER BY HbA1c DESC;
END
GO

GRANT EXECUTE ON [NDV].[GetIncretinUsersWithHighHbA1c] TO [FastTrak]
GO