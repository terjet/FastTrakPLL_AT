SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetActiveSingleVar]( @StudyId INT, @ItemId INT, @EnumVal INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, v.StatusText AS InfoText, v.GenderId
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( @ItemId, NULL ) ev ON ev.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND ev.EnumVal = @EnumVal
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetActiveSingleVar] TO [FastTrak]
GO