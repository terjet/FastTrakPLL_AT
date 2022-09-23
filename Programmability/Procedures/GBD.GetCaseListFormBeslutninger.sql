SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListFormBeslutninger] (@StudyId INT) AS
BEGIN
  SELECT v.*, 
    v.StatusText + '. Dato: ' + dbo.ShortTime( frm.EventTime) AS InfoText
  FROM dbo.GetLastFormTableByName( 'GBD_BESLUTNINGER', GETDATE() + 1 ) frm
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = frm.PersonId
  WHERE v.StudyId = @StudyId;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormBeslutninger] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormBeslutninger] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormBeslutninger] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormBeslutninger] TO [Vernepleier]
GO