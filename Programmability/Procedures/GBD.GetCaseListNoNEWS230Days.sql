SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNoNEWS230Days]( @StudyId INT ) AS
BEGIN
  SELECT v.*,
    'Utfylt: ' + ISNULL(CONVERT(VARCHAR, lastNEWS2.EventTime, 104), 'Aldri') + '. ' + ISNULL(beslutn.OptionText, 'NEWS2-rutine ikke vurdert.') AS InfoText
  FROM ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastFormTableByName ('NEWS2', NULL) lastNEWS2 ON lastNEWS2.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(5970, NULL) beslutn ON beslutn.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND ( ( lastNEWS2.EventTime < GETDATE() - 30 ) OR ( lastNEWS2.EventTime IS NULL ) )
  AND ( beslutn.EnumVal = 1 OR beslutn.EnumVal IS NULL )
  ORDER BY ISNULL(beslutn.EnumVal, 2), lastNEWS2.EventTime;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoNEWS230Days] TO [FastTrak]
GO