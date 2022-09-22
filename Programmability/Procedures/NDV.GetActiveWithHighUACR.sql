SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetActiveWithHighUACR]( @StudyId INT, @UACRCutoff FLOAT ) AS
BEGIN
  -- Create temporary table
  SELECT PersonId,DOB,FullName,GroupName,dbo.GetLastLab(PersonId,'UACR') AS UACR INTO #temp
  FROM NDV.AllActive;
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,'UACR = ' + CONVERT(VARCHAR,UACR) as InfoText 
  FROM #temp WHERE UACR >= @UACRCutoff
  ORDER BY UACR DESC
END
GO

GRANT EXECUTE ON [NDV].[GetActiveWithHighUACR] TO [FastTrak]
GO