SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDrug]( @StudyId INT, @ATC VARCHAR(7) ) AS
BEGIN
  SELECT vcl.PersonId, vcl.DOB, vcl.FullName, vcl.GenderId, vcl.GroupName, COUNT( dt.TreatId ) AS TreatCount,
  CAST(' ' AS VARCHAR(256) ) AS InfoText
  INTO #tempList
  FROM dbo.OngoingTreatment dt
    JOIN dbo.ViewActiveCaseListStub vcl 
      ON vcl.PersonId = dt.PersonId AND vcl.StudyId = @StudyId
  WHERE dt.ATC COLLATE Latin1_General_CI_AI LIKE @ATC COLLATE Latin1_General_CI_AI
  GROUP BY vcl.PersonId, vcl.DOB, vcl.FullName, vcl.GenderId, vcl.GroupName;

  UPDATE #tempList SET InfoText = ( SELECT TOP 1 ISNULL(RTRIM(mt.TreatDesc),'?') + ': ' + ISNULL(DrugName,'?') + ' - ' + ISNULL(StartReason,'?')
    FROM dbo.OnGoingTreatment ot 
    JOIN dbo.MetaTreatType mt ON mt.TreatType=ot.TreatType
    WHERE PersonId=#tempList.PersonId AND ATC COLLATE Latin1_General_CI_AI LIKE @ATC COLLATE Latin1_General_CI_AI ORDER BY mt.TreatType DESC );
  UPDATE #tempList SET InfoText = InfoText + ' (pluss ett annet prep)'
    WHERE TreatCount = 2;
  UPDATE #tempList SET InfoText = InfoText + ' (pluss ' + CONVERT(VARCHAR,TreatCount-1) + ' andre prep)'
    WHERE TreatCount > 2;
  SELECT PersonId, DOB, FullName, GroupName, GenderId, InfoText
    FROM #TempList ORDER By FullName;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListDrug] TO [Administrator]
GO