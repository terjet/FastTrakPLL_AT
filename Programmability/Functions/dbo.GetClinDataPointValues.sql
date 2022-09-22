SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetClinDataPointValues]( @StudyId INT, @PersonId INT, @FormName VARCHAR(24), @ItemId INT )
RETURNS @ClinDataPoint TABLE (
	ClinFormId INT NOT NULL PRIMARY KEY,
	SignedAt DATETIME,
	FormName VARCHAR(24),
	FormTitle VARCHAR(128),
	DTVal DATETIME,
	EnumVal INT,
	TextVal VARCHAR(MAX)
)
AS
BEGIN
	INSERT INTO @ClinDataPoint (ClinFormId, SignedAt, FormName, FormTitle, DTVal, EnumVal, TextVal)
	SELECT TOP (1)
		cf.ClinFormId,
		cf.SignedAt,
		mf.FormTitle,
		mf.FormName,
		cdp.DTVal,
		cdp.EnumVal,
		cdp.TextVal
	FROM dbo.ClinForm cf
	JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
	LEFT JOIN dbo.ClinDataPoint cdp ON cdp.EventId = cf.EventId
		AND cdp.ItemId = @ItemId
	LEFT JOIN dbo.MetaFormItem mfi ON mfi.ItemId = cdp.ItemId
		AND mfi.FormId = cf.FormId
	JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
	WHERE mf.FormName = @FormName
	AND cf.FormStatus = 'L'
	AND ce.StudyId = @StudyId
	AND ce.PersonId = @PersonId
	ORDER BY ce.EventNum DESC
	RETURN;
END
GO