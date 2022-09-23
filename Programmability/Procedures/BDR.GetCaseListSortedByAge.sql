SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListSortedByAge]( @StudyId INT ) AS
BEGIN
  SET LANGUAGE NORWEGIAN;
  SELECT v.*,
    FORMAT( DATEDIFF( DD, v.DOB, GETDATE() - 15 ) / 365.25, 'Alder ~ 0.# år' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  WHERE v.StudyId = @StudyId
  ORDER BY DOB;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListSortedByAge] TO [FastTrak]
GO