SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetActiveDoubleVar]( @StudyId INT, @ItemId1 INT, @EnumVal1 INT, @ItemId2 INT, @EnumVal2 INT ) AS
BEGIN
  SELECT v.*, v.StatusText AS InfoText  
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.GetLastEnumValuesTable( @ItemId1, NULL ) ev1 ON ev1.PersonId = v.PersonId
  JOIN dbo.GetLastEnumValuesTable( @ItemId2, NULL ) ev2 ON ev2.PersonId = v.PersonId
  WHERE ( v.StudyId = @StudyId ) AND ( ev1.EnumVal = @EnumVal1 ) AND ( ev2.EnumVal = @EnumVal2 )
  ORDER BY v.FullName;
END;
GO

GRANT EXECUTE ON [dbo].[GetActiveDoubleVar] TO [FastTrak]
GO