SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListPhoneConsultations]( @StudyId INT, @StartAt DateTime, @StopAt DateTime ) AS
BEGIN
  EXEC dbo.GetFormClassInPeriod @StudyId, 'DIAPOL_TLF', @StartAt, @StopAt;
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListPhoneConsultations] TO [FastTrak]
GO