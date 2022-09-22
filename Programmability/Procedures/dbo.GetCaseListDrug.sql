SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDrug]( @StudyId INT, @ATC VARCHAR(7) ) AS
BEGIN
  SELECT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName,count(dt.TreatId) as TreatCount,
  CAST(' ' AS VARCHAR(256) ) AS InfoText
  INTO #tempList
  FROM OngoingTreatment dt
    JOIN ViewActiveCaseListStub vcl ON vcl.PersonId=dt.PersonId AND vcl.StudyId=@StudyId
  WHERE dt.ATC LIKE @ATC COLLATE Latin1_General_CI_AI
  GROUP BY vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName;

  UPDATE #tempList SET InfoText = ( SELECT TOP 1 ISNULL(RTRIM(mt.TreatDesc),'?') + ': ' + ISNULL(DrugName,'?') + ' - ' + ISNULL(StartReason,'?')
    FROM OnGoingTreatment ot JOIN MetaTreatType mt ON mt.TreatType=ot.TreatType
    WHERE PersonId=#tempList.PersonId AND ATC LIKE @ATC COLLATE Latin1_General_CI_AI ORDER BY mt.TreatType DESC );
  UPDATE #tempList SET InfoText = InfoText + ' (pluss ett annet prep)'
    WHERE TreatCount = 2;
  UPDATE #tempList SET InfoText = InfoText + ' (pluss ' + CONVERT(VARCHAR,TreatCount-1) + ' andre prep)'
    WHERE TreatCount > 2;
  SELECT PersonId,DOB,FullName,GroupName,InfoText
    FROM #TempList ORDER By FullName
END;
GO