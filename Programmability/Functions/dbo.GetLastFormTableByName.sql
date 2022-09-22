SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastFormTableByName]( @FormName VARCHAR(24), @CutoffDate DateTime )
RETURNS @FormList TABLE (
  PersonId INT NOT NULL PRIMARY KEY,
  ClinFormId INT NOT NULL,
  EventId INT NOT NULL,
  EventTime DATETIME NOT NULL,
  CreatedAt DATETIME NOT NULL,
  SignedAt DATETIME NULL
) AS
BEGIN 
  DECLARE @CutoffNum INT;
  SET @CutoffNum = dbo.FnEventTimeToNum( ISNULL( @CutoffDate, GETDATE() + 1 ) );
  INSERT INTO @FormList
    SELECT a.PersonId, a.ClinFormId, a.EventId, a.EventTime, a.CreatedAt, a.SignedAt
    FROM ( SELECT ce.PersonId, cf.ClinFormId, ce.EventId, ce.EventTime, cf.CreatedAt, cf.SignedAt,
        ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC, ce.EventId DESC ) AS ReverseOrderNo
      FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce
        ON ce.EventId = cf.EventId
      JOIN dbo.MetaForm mf
        ON mf.FormId = cf.FormId
      WHERE mf.FormName = @FormName AND ce.EventNum < @CutoffNum AND cf.DeletedAt IS NULL ) a
    WHERE a.ReverseOrderNo = 1;
  RETURN;
END
GO