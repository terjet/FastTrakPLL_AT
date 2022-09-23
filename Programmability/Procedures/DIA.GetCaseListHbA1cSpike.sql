SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [DIA].[GetCaseListHbA1cSpike]( @StudyId INT ) AS 
BEGIN
  SET NOCOUNT ON;
  SELECT DISTINCT ld.PersonId, CONVERT(DATE,LabDate) AS LabDate, NumResult, ROW_NUMBER() OVER ( Partition BY ld.PersonId ORDER BY LabDate DESC ) AS rnk 
    INTO #temp
  FROM dbo.LabData ld
    JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
    JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ld.PersonId
  WHERE lc.LabClassId = 1058;
  SELECT v.*, 
    CONCAT( 'HbA1c økt fra ', t2.NumResult, ' til ', t1.NumResult, ' på ', DATEDIFF(DD,t2.LabDate,t1.LabDate),' dager ( ', CONVERT(VARCHAR,t2.LabDate,4 ), ' - ', CONVERT(VARCHAR,t1.LabDate,4), ' ).'  ) AS InfoText
  FROM #temp t1
  JOIN #temp t2 ON t1.PersonId = t2.PersonId
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = t1.PersonId
  WHERE ( t1.rnk = 1 AND t2.rnk = 2 ) AND ( t1.NumResult >= t2.NumResult + 5 )
  ORDER BY t1.NumResult - t2.NumResult DESC, v.FullName;
END;
GO

GRANT EXECUTE ON [DIA].[GetCaseListHbA1cSpike] TO [FastTrak]
GO