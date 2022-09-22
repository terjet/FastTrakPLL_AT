SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastFormTable]( @FormId INT, @CutoffDate DateTime )
RETURNS @FormList TABLE (
  PersonId INT NOT NULL PRIMARY KEY,
  ClinFormId INT NOT NULL,
  EventId INT NOT NULL,
  EventTime DATETIME NOT NULL,
  CreatedAt DATETIME NOT NULL,
  SignedAt DATETIME NULL
) AS
BEGIN 
  IF @CutoffDate IS NULL SET @CutoffDate = GETDATE()+1;
  INSERT INTO @FormList
    SELECT a.PersonId, a.ClinFormId, a.EventId, a.EventTime, a.CreatedAt, a.SignedAt
    FROM (SELECT ce.PersonId, cf.ClinFormId, ce.EventId, ce.EventTime, cf.CreatedAt, cf.SignedAt,
        RANK() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC) AS ReverseOrderNo
      FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce
        ON ce.EventId = cf.EventId
      JOIN dbo.MetaForm mf
        ON mf.FormId = cf.FormId
      WHERE mf.FormId = @FormId AND ce.EventTime < @CutoffDate AND cf.DeletedAt IS NULL ) a
    WHERE a.ReverseOrderNo = 1;
  RETURN;
END
GO

GRANT SELECT ON [dbo].[GetLastFormTable] TO [QuickStat]
GO