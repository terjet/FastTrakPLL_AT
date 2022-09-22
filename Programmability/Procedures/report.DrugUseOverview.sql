SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[DrugUseOverview]( @StudyId INT, @CenterId INT = NULL, @ATCLevel INT = 7 ) AS
BEGIN
  SELECT DISTINCT ac.PersonId,ac.CenterId,
    substring(dt.Atc,1,@ATCLevel) as AtcFragment INTO #DrugUse FROM DrugTreatment dt
  JOIN AllActiveCases ac ON ac.PersonId=dt.PersonId AND ac.StudyId=@StudyId
  WHERE ( dt.StopAt IS NULL ) OR ( dt.StopAt > getdate() );
   
  SELECT CenterId,CenterName,dbo.GetCaseCountByStudyCenter(@StudyId,CenterId) as PatCount INTO #tempCenter 
  FROM StudyCenter WHERE ISNULL(@CenterId,CenterId)=CenterId;

  SELECT ISNULL(k.AtcCode,'XXXXX') AS AtcCode,ISNULL(k.AtcName,'AtcCode Missing') as AtcName, 
    c.CenterId,c.CenterName,c.PatCount,count(du.PersonId) As UsingDrug,
    ROUND(100*CONVERT(FLOAT,count(du.PersonId))/c.PatCount,1) AS PercentUse
  INTO #ResultSet               
  FROM #tempCenter c 
    LEFT OUTER JOIN #DrugUse du ON du.CenterId=c.CenterId 
    LEFT OUTER JOIN KBATCIndex k ON k.AtcCode=du.AtcFragment
  WHERE c.PatCount > 0   
  GROUP BY k.AtcCode,k.AtcName,c.CenterId,c.CenterName,c.PatCount;
  SELECT * FROM #ResultSet WHERE UsingDrug > 1 ORDER BY PercentUse DESC;
END
GO