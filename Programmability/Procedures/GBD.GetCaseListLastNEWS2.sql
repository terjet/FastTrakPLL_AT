SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListLastNEWS2]( @StudyId INT ) AS
BEGIN
  SELECT v.*,
    'Utfylt: ' + ISNULL(CONVERT(VARCHAR, lastNEWS2.EventTime, 104), 'Aldri') + '. ' +
    CASE
      WHEN beslutn.EnumVal IS NULL THEN 'NEWS2-rutine ikke vurdert.'
      WHEN lastNEWS2.EventTime IS NULL THEN beslutn.OptionText + '.' -- «NEWS2 skal utføres.»
      WHEN (lastNEWS2.EventTime < GETDATE() - 30) AND beslutn.EnumVal = 1 THEN 'NEWS2 bør utføres på nytt.'
      ELSE '' -- tom streng for pasientar som har utfylt NEWS2 siste månaden i tråd med rutine
    END AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastFormTableByName ('NEWS2', NULL) lastNEWS2 ON lastNEWS2.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(5970, NULL) beslutn ON beslutn.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND ( beslutn.EnumVal = 1 OR beslutn.EnumVal IS NULL )
  ORDER BY ISNULL(beslutn.EnumVal, 2), lastNEWS2.EventTime;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListLastNEWS2] TO [FastTrak]
GO