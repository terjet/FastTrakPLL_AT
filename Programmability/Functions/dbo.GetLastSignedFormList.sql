SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastSignedFormList] (@StudyId INT, @FormName VARCHAR(24))
RETURNS @FormList TABLE (
  PersonId INT NOT NULL PRIMARY KEY,
  ClinFormId INT NOT NULL,
  EventTime DATETIME NOT NULL
) AS
BEGIN
  INSERT INTO @FormList
    SELECT a.PersonId, a.ClinFormId, a.EventTime
    FROM (SELECT ce.PersonId, cf.ClinFormId, ce.EventTime,
        RANK() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC) AS OrderNo
      FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce
        ON ce.EventId = cf.EventId
      JOIN dbo.MetaForm mf
        ON mf.FormId = cf.FormId
      WHERE ce.StudyId = @StudyId
      AND mf.FormName = @Formname
      AND cf.FormStatus = 'L') a
    WHERE a.OrderNo = 1;
  RETURN;
END
GO