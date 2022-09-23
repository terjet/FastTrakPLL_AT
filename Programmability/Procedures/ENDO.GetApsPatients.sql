SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetApsPatients]( @StudyId INT, @ApsType INT ) AS
BEGIN

  DECLARE @ItemId INT = 6607;
  IF @ApsType = 1 SET @ItemId = 5069;

  SELECT v.*, v.StatusText AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( @ItemId, NULL ) t ON t.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND t.EnumVal = @ApsType;

END
GO

GRANT EXECUTE ON [ENDO].[GetApsPatients] TO [FastTrak]
GO