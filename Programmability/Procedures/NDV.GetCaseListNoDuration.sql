SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListNoDuration]( @StudyId INT ) AS
BEGIN
  SELECT v.*, 'Varighet mangler' AS InfoText
  FROM dbo.ViewActiveCaseListStub v                   
  LEFT JOIN dbo.GetLastQuantityTable( 3486, GETDATE()) qt 
    ON ( qt.PersonId = v.PersonId ) AND ( qt.Quantity >= 1900 )
  WHERE ( v.StudyId = @StudyId ) AND ( qt.Quantity IS NULL )
  ORDER BY FullName;                                                                            
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListNoDuration] TO [FastTrak]
GO