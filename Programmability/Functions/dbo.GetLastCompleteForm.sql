SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastCompleteForm] (@StudyId INT, @PersonId INT, @FormName VARCHAR(24))
RETURNS DATETIME AS
BEGIN
  DECLARE @LastFormDate DATETIME;
  SELECT @LastFormDate = MAX(ce.EventTime)
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON (cf.EventId = ce.EventId) AND (ce.StudyId = @StudyId) AND (ce.PersonId = @PersonId) AND (cf.DeletedAt IS NULL) AND (cf.FormComplete = 100)
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = @FormName;
  RETURN @LastFormDate;
END
GO