SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN05AexLowDoseH04]( @StudyId INT ) AS
BEGIN
  SET LANGUAGE Norwegian;
  SELECT v.PersonId, v.DOB, v.FullName, v.GenderId, v.GroupName,
  DrugName + ' ' + ISNULL(FORMAT( agg.Dose24hDD, 'N'  ),'?') + '/24h (' + ATC + ')' AS  InfoText
  FROM 
  (
    SELECT *, RANK() OVER ( PARTITION BY PersonId ORDER BY TreatId DESC ) AS ReverseOrderNo
    FROM
    ( 
      SELECT PersonId, TreatId, ATC, DrugName, ot1.Dose24hDD FROM OngoingTreatment ot1 
      WHERE ATC  LIKE 'N05A%' AND TreatType = 'F'
      EXCEPT 
      SELECT PersonId, TreatId, ATC, DrugName, ot2.Dose24hDD FROM OngoingTreatment ot2
      WHERE ATC = 'N05AH04' AND ot2.Dose24hDD < 100
    ) ot
  ) agg
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = agg.PersonId 
  WHERE  agg.ReverseOrderNo = 1 AND v.StudyId = @StudyId
  ORDER BY v.FullName;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05AexLowDoseH04] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05AexLowDoseH04] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05AexLowDoseH04] TO [Lege]
GO