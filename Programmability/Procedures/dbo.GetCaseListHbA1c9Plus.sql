SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListHbA1c9Plus]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,
    dbo.GetLastValue( v.PersonId, 'HBA1C') as HbA1c,
    dbo.GetLastQuantity( v.PersonId, 'NDV_TYPE') AS DiaType
  INTO #TempTable 
  FROM ViewActiveCaseListStub v
  WHERE v.StudyId=@StudyId;
  SELECT PersonId,DOB,FullName,GroupName,
  ISNULL('Type-' +
    SUBSTRING(CONVERT( VARCHAR,DiaType),1,1),'Uspes') + ', HbA1c: ' +
    SUBSTRING(CONVERT(VARCHAR,ROUND(HbA1c,1)),1,4) AS InfoText
  FROM #TempTable WHERE HBA1C >= 9 ORDER BY HbA1c DESC
END
GO