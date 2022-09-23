SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListHbA1cFalling]( @StudyId INT ) AS
BEGIN
  SELECT v.*,  
    ISNULL(FORMAT( ld.Quantity, 'HbA1c = # mmol/mol' ),'(HbA1c mangler)' ) AS InfoText 
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastQuantityTable( 3018, NULL ) ld ON ld.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY ISNULL(ld.Quantity,999) DESC;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListHbA1cFalling] TO [FastTrak]
GO