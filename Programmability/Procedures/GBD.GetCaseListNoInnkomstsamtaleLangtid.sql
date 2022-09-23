SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNoInnkomstsamtaleLangtid] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, CONCAT('Status: ', v.StatusText) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.StudyStatus ss ON v.StudyId = ss.StudyId AND v.StatusId = ss.StatusId 
  LEFT JOIN dbo.GetLastEnumValuesTable(121, NULL) StayType ON v.PersonId = StayType.PersonId
  LEFT JOIN dbo.GetLastSignedFormList(@StudyId, 'GBD_INN_LANGTID') InnkomstsamtaleLangtid on InnkomstsamtaleLangtid.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND InnkomstsamtaleLangtid.EventTime IS NULL
    AND (ss.LongTerm = 1 OR (ss.LongTerm IS NULL AND StayType.EnumVal = 5 )) -- sjekk for langtid
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoInnkomstsamtaleLangtid] TO [FastTrak]
GO