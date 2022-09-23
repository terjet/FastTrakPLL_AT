SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListLongTermNoStratify6Months]( @StudyId INT ) AS
BEGIN
  SELECT v.*, LastSignedStratify.EventTime AS StratifyDate,
    'Utfylt: ' + ISNULL(CONVERT(VARCHAR, LastSignedStratify.EventTime, 104), 'Aldri') AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.StudyStatus ss ON v.StudyId = ss.StudyId AND v.StatusId = ss.StatusId 
  LEFT JOIN dbo.GetLastEnumValuesTable(121, NULL) StayType ON v.PersonId = StayType.PersonId
  LEFT JOIN dbo.GetLastSignedFormList (@StudyId, 'STRATIFY') LastSignedStratify ON LastSignedStratify.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND (LastSignedStratify.EventTime IS NULL OR DATEDIFF(DD, LastSignedStratify.EventTime, GETDATE()) > 183 )
    AND (ss.LongTerm = 1 OR (ss.LongTerm IS NULL AND StayType.EnumVal = 5 )) -- sjekk for langtid
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListLongTermNoStratify6Months] TO [FastTrak]
GO