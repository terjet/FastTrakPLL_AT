SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListLDLAbove25]( @StudyId INT, @DiaType INT, @Treated BIT, @MinAge INT, @MaxAge INT ) AS
BEGIN
  DECLARE @FirstExcludedDOB DATETIME = DATEADD( YEAR, -@MaxAge - 1, GETDATE() );
  DECLARE @LastDOB DATETIME = DATEADD( YEAR, -@MinAge, GETDATE() )

  SELECT p.PersonId, p.DOB, p.FullName, sg.StudyId, sg.GroupId, sg.GroupName, p.GenderId, sc.StatusId,
    FORMAT( LDL.NumResult, 'LDL = 0.##', 'no' ) as InfoText 
      FROM NDV.GetRecentPatientsTable(@DiaType, GETDATE(), 15) recentPatientsByType
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = recentPatientsByType.PersonId AND v.StudyId = @StudyId
  JOIN dbo.Person p ON p.PersonId = recentPatientsByType.PersonId
  LEFT JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId AND sc.StudyId = @StudyId
  LEFT JOIN dbo.StudyGroup sg ON sg.GroupId = sc.GroupId AND sg.StudyId = sc.StudyId 
  LEFT JOIN dbo.GetLastLabDataTable(35, GETDATE()) LDL ON LDL.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3337, NULL) treated ON treated.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3397, NULL) NDV_CHD ON NDV_CHD.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3398, NULL) stroke ON stroke.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3414, NULL) amputation ON amputation.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable(3417, NULL) arterialSurgery ON arterialSurgery.PersonId = p.PersonId
  LEFT JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId = @StudyId
  WHERE LDL.NumResult > 2.5 AND LDL.LabDate >= DATEADD( MONTH, -30, GETDATE() ) AND
    ( ISNULL(NDV_CHD.EnumVal, -1) <> 1 AND ISNULL(stroke.EnumVal, -1) <> 1 AND ISNULL(amputation.EnumVal, -1) NOT IN (2, 3) AND ISNULL(arterialSurgery.EnumVal, -1) <> 1 ) 
    AND p.DOB > @FirstExcludedDOB AND p.DOB <= @LastDOB AND
    CASE 
        WHEN @Treated = 1 AND treated.EnumVal = 1 THEN 1
        WHEN @Treated = 0 AND ( treated.EnumVal IS NULL OR treated.EnumVal != 1 ) THEN 1
        ELSE 0
    END = 1
    AND ( ( su.GroupId = sc.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ) )
  ORDER BY LDL.NumResult DESC, p.FullName
END;
GO

GRANT EXECUTE ON [NDV].[GetCaseListLDLAbove25] TO [FastTrak]
GO