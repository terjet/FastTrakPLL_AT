SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListShortTermNoStratify]( @StudyId INT ) AS
BEGIN
  SELECT v.*, Arrival.DTVal AS GBD_INN, LastSignedStratify.EventTime AS StratifyDate, 'Utfylt: ' + ISNULL(CONVERT(VARCHAR, LastSignedStratify.EventTime, 104), 'Aldri') AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.StudyStatus ss ON v.StatusId = ss.StatusId AND v.StudyId = ss.StudyId
  LEFT JOIN dbo.GetLastEnumValuesTable(121, NULL) StayType ON v.PersonId = StayType.PersonId
  LEFT JOIN dbo.GetLastDateTable(4085, NULL) Arrival ON Arrival.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastSignedFormList(@StudyId, 'STRATIFY') LastSignedStratify ON LastSignedStratify.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND
    (LastSignedStratify.EventTime IS NULL OR Arrival.DTVal > LastSignedStratify.EventTime) -- sjekk om GBD_inn > StratifyDate
    AND (ss.LongTerm = 0 OR (ss.LongTerm IS NULL AND StayType.EnumVal <> 5)) -- sjekk for korttid
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListShortTermNoStratify] TO [FastTrak]
GO