SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListFalltiltak] ( @StudyId INT ) AS
BEGIN
SELECT v.*, Tiltaksplan.CreatedAt AS TiltaksplanOppretta,
    CONCAT('Stratify-skår ', StratifyScore.EnumVal, '. Tiltaksplan ', ISNULL( CONVERT(VARCHAR, Tiltaksplan.EventTime, 104) + '. ' +
    ISNULL('Evalueres ' + CONVERT(VARCHAR, Evalueringsdato.DTVal, 104) + '.', 'Evalueringsdato ikke utfylt.'), 'aldri utfylt.')) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable(9257, NULL) StratifyScore ON v.PersonId = StratifyScore.PersonId
  LEFT JOIN dbo.GetLastFormTableByName ('GBD_FALL_TILTAK', NULL) Tiltaksplan ON Tiltaksplan.PersonId = v.PersonId
  LEFT JOIN dbo.ClinDataPoint Evalueringsdato ON Evalueringsdato.EventId = Tiltaksplan.EventId AND Evalueringsdato.ItemId = 10168
  WHERE v.StudyId = @StudyId AND StratifyScore.EnumVal >= 2 
  ORDER BY CASE WHEN Tiltaksplan.CreatedAt IS NULL THEN 1 ELSE 0 END, ISNULL(Evalueringsdato.DTVal, Tiltaksplan.CreatedAt); 
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListFalltiltak] TO [FastTrak]
GO