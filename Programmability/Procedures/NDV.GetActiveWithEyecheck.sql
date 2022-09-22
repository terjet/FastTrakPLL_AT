﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetActiveWithEyecheck]( @StudyId INT ) AS
BEGIN
  -- Create temporary table
  SELECT PersonId,DOB,FullName,GroupName,dbo.GetLastDTVal(PersonId,'NDV_EYECHECK_DATE') AS NDV_EYECHECK_DATE INTO #temp 
  FROM NDV.AllActive;
  UPDATE #temp SET NDV_EYECHECK_DATE = NULL WHERE NDV_EYECHECK_DATE < DOB;
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,ISNULL(CONVERT(VARCHAR,NDV_EYECHECK_DATE,104),'Ukjent') as InfoText 
  FROM #temp 
  ORDER BY NDV_EYECHECK_DATE
END
GO