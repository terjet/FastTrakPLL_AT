SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[DrugUseOverview]( @StudyId INT, @CenterId INT = NULL, @ATCLevel INT = 7 ) AS
BEGIN
  SELECT DISTINCT ac.PersonId, ac.CenterId,
    SUBSTRING(dt.Atc,1,@ATCLevel) AS AtcFragment INTO #DrugUse 
  FROM dbo.DrugTreatment dt
  JOIN dbo.AllActiveCases ac ON ac.PersonId=dt.PersonId AND ac.StudyId=@StudyId
  WHERE ( dt.StopAt IS NULL ) OR ( dt.StopAt > getdate() );
   
  SELECT CenterId, CenterName, dbo.GetCaseCountByStudyCenter(@StudyId,CenterId) AS PatCount 
  INTO #tempCenter 
  FROM dbo.StudyCenter WHERE ISNULL(@CenterId,CenterId)=CenterId;

  SELECT ISNULL(k.AtcCode,'XXXXX') AS AtcCode,ISNULL(k.AtcName,'(ATC mangler)') AS AtcName, 
    c.CenterId, c.CenterName, c.PatCount, count(du.PersonId) AS UsingDrug,
    ROUND(100*CONVERT(FLOAT,count(du.PersonId))/c.PatCount,1) AS PercentUse
  INTO #ResultSet               
  FROM #tempCenter c 
    LEFT OUTER JOIN #DrugUse du ON du.CenterId=c.CenterId 
    LEFT OUTER JOIN dbo.KBATCIndex k ON k.AtcCode=du.AtcFragment
  WHERE c.PatCount > 0   
  GROUP BY k.AtcCode,k.AtcName,c.CenterId,c.CenterName,c.PatCount;
  SELECT * FROM #ResultSet WHERE UsingDrug > 1 ORDER BY PercentUse DESC;
END
GO

GRANT EXECUTE ON [report].[DrugUseOverview] TO [Farmasøyt]
GO

GRANT EXECUTE ON [report].[DrugUseOverview] TO [FastTrak]
GO

GRANT EXECUTE ON [report].[DrugUseOverview] TO [Gruppeleder]
GO

GRANT EXECUTE ON [report].[DrugUseOverview] TO [Lege]
GO

GRANT EXECUTE ON [report].[DrugUseOverview] TO [Sykepleier]
GO

GRANT EXECUTE ON [report].[DrugUseOverview] TO [Vernepleier]
GO