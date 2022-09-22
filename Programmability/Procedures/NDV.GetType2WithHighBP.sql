SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetType2WithHighBP]( @StudyId INT, @SysBpCutoff FLOAT ) AS
BEGIN
  -- Create temporary table
  SELECT PersonId,DOB,FullName,GroupName,dbo.GetLastQuantity(PersonId,'SYSBP') AS SysBP INTO #temp
  FROM NDV.Type2;
  -- Read data
  SELECT PersonId,DOB,FullName,GroupName,'SysBT = ' + CONVERT(VARCHAR,SysBP) as InfoText 
  FROM #temp WHERE SysBP >= @SysBPCutoff
  ORDER BY SysBP DESC
END
GO

GRANT EXECUTE ON [NDV].[GetType2WithHighBP] TO [FastTrak]
GO