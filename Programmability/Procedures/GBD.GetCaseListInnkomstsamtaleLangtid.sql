SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListInnkomstsamtaleLangtid] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, CONCAT('Skjemadato: ', CONVERT(VARCHAR, InnkomstsamtaleLangtid.EventTime, 104)) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.StudyStatus ss ON v.StudyId = ss.StudyId AND v.StatusId = ss.StatusId 
  JOIN dbo.GetLastSignedFormList(@StudyId, 'GBD_INN_LANGTID') InnkomstsamtaleLangtid on InnkomstsamtaleLangtid.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(121, NULL) StayType ON v.PersonId = StayType.PersonId
  WHERE v.StudyId = @StudyId
    AND (ss.LongTerm = 1 OR (ss.LongTerm IS NULL AND StayType.EnumVal = 5 )) -- sjekk for langtid
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListInnkomstsamtaleLangtid] TO [FastTrak]
GO