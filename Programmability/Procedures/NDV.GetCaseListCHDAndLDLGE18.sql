SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListCHDAndLDLGE18]( @StudyId INT, @DiaType INT ) AS
BEGIN
  SELECT p.PersonId, p.DOB, p.FullName, sg.StudyId, sg.GroupId, sg.GroupName, p.GenderId, sc.StatusId,
    FORMAT( LDL.NumResult, 'LDL = 0.##', 'no' ) as InfoText 
      FROM NDV.GetRecentPatientsTable(@DiaType, GETDATE(), 15) recentPatientsByType
  JOIN dbo.Person p ON p.PersonId = recentPatientsByType.PersonId
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = recentPatientsByType.PersonId AND v.StudyId = @StudyId
  LEFT JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId AND sc.StudyId = @StudyId
  LEFT JOIN dbo.StudyGroup sg ON sg.GroupId = sc.GroupId AND sg.StudyId = sc.StudyId
  LEFT JOIN dbo.GetLastLabDataTable(35, GETDATE()) LDL ON LDL.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3397, NULL) NDV_CHD ON NDV_CHD.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3398, NULL) stroke ON stroke.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3414, NULL) amputation ON amputation.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3417, NULL) arterialSurgery ON arterialSurgery.PersonId = p.PersonId
  LEFT JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId = @StudyId
  WHERE LDL.NumResult >= 1.8 AND LDL.LabDate >= DATEADD( MONTH, -30, GETDATE() ) AND 
    ( NDV_CHD.EnumVal = 1 OR stroke.EnumVal = 1 OR amputation.EnumVal IN (2, 3) OR arterialSurgery.EnumVal = 1 )
    AND ( ( su.GroupId = sc.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ) )
  ORDER BY LDL.NumResult DESC, p.FullName;
END;
GO

GRANT EXECUTE ON [NDV].[GetCaseListCHDAndLDLGE18] TO [FastTrak]
GO