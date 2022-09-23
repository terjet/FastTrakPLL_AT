SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetPatientsInProject]( @StudyId INT, @ProjectVariableId INT ) AS
BEGIN 
 SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, v.GenderId, v.StatusText AS InfoText
  FROM dbo.ViewActiveCaseListStub v   
  LEFT JOIN dbo.GetLastEnumValuesTable( @ProjectVariableId, NULL ) graveOppfolging ON graveOppfolging.PersonId = v.PersonId     
  WHERE v.StudyId = @StudyId AND graveOppfolging.EnumVal = 1
END
GO

GRANT EXECUTE ON [ROAS].[GetPatientsInProject] TO [FastTrak]
GO