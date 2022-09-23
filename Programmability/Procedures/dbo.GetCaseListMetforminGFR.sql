SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMetforminGFR]( @StudyId INT ) AS
BEGIN
  DECLARE @CalcAt DateTime;
  SET @CalcAt = getdate();
  SELECT DISTINCT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName,dbo.GetMDRD( vcl.PersonId,@CalcAt ) AS GFR,
  '....................................................................' as InfoText
  INTO #temp FROM dbo.OngoingTreatment dt
    JOIN ViewActiveCaseListStub vcl ON vcl.PersonId=dt.PersonId AND vcl.StudyId=@StudyId
    JOIN dbo.OngoingTreatment d on d.PersonId=vcl.PersonId and d.ATC like 'A10BA02';
  UPDATE #temp SET InfoText = ( 'eGFR = ' + CONVERT(VARCHAR,GFR) + ' mL/min/1.73m2' ) WHERE NOT GFR IS NULL;
  UPDATE #temp SET InfoText = ( 'OBS eGFR = ' + CONVERT(VARCHAR,GFR) + ' mL/min/1.73m2. Vurder å seponere metformin.' ) WHERE GFR<60;
  UPDATE #temp SET InfoText = ( 'eGFR > 80' ) WHERE GFR > 80;
  UPDATE #temp SET InfoText = ( 'Oppdatert S-Kreatinin mangler!' ),GFR=-1 WHERE GFR IS NULL;
  SELECT Personid,DOB,FullName,GroupName,InfoText FROM #temp order by GFR;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListMetforminGFR] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListMetforminGFR] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListMetforminGFR] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListMetforminGFR] TO [Vernepleier]
GO