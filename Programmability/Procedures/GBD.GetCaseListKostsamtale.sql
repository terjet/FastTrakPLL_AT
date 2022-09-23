SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListKostsamtale] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, CONCAT('Status: ', v.StatusText, '. Skjemadato: ', CONVERT(VARCHAR, Kostsamtale.EventTime, 104)) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastSignedFormList(@StudyId, 'SAMTALE_KOST') Kostsamtale on Kostsamtale.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListKostsamtale] TO [FastTrak]
GO