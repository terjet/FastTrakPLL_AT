SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastDTValOnForm]( @FormName VARCHAR(24), @ItemId INT, @PersonId INT, @LockedOnly INT = 1 )
RETURNS DATETIME AS
BEGIN
  /* Note: Returns DTValue even if it is NULL on the latest form. */
  DECLARE @RetVal DATETIME;
  SET @RetVal = (SELECT TOP 1
      cdp.DTVal
    FROM dbo.ClinEvent ce
    JOIN dbo.ClinForm cf
      ON cf.EventId = ce.EventId
    JOIN dbo.MetaForm mf
      ON mf.FormId = cf.FormId
      AND (mf.FormName = @FormName)
    LEFT JOIN dbo.ClinDataPoint cdp
      ON cdp.EventId = ce.EventId
      AND cdp.ItemId = @ItemId
    WHERE (ce.PersonId = @PersonId)
    AND ((cf.FormStatus = 'L')
    OR (@LockedOnly = 0))
    ORDER BY ce.EventNum DESC);
  RETURN @RetVal;
END
GO