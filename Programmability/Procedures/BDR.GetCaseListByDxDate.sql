SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListByDxDate] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, ISNULL(gldt.DTVal, GETDATE()) AS DTValOrder, 
    ISNULL('Diagnosedato: ' + FORMAT( gldt.DTVal, 'd', 'no-no' ), '(uoppgitt)') AS InfoText 
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastDateTable(3323, NULL) gldt ON v.PersonId = gldt.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY DTValOrder DESC;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListByDxDate] TO [FastTrak]
GO