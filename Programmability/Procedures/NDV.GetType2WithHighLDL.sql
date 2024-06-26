﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetType2WithHighLDL]( @StudyId INT, @LDLCutoff FLOAT, @MinAge INT = 18 ) AS
BEGIN
  DECLARE @LastDOB DateTime;
  SET @LastDOB = DATEADD( year, -@MinAge,getdate() )
  -- Create temporary table
  SELECT PersonId,DOB,FullName,GroupName,dbo.GetLastLab(PersonId,'LDL') AS LDL INTO #temp
  FROM NDV.Type2 WHERE DOB <= @LastDOB;
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,'LDL = ' + CONVERT(VARCHAR,LDL) as InfoText 
  FROM #temp WHERE LDL >= @LDLCutoff
  ORDER BY LDL DESC
END
GO

GRANT EXECUTE ON [NDV].[GetType2WithHighLDL] TO [FastTrak]
GO