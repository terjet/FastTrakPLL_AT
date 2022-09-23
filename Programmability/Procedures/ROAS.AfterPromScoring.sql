SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[AfterPromScoring] AS
BEGIN
  SET NOCOUNT ON;
  MERGE dbo.ClinForm AS trg
    USING ( SELECT ce.EventId 
      FROM dbo.ClinForm cf 
      JOIN dbo.ClinEvent ce on ce.EventId= cf.FormId WHERE cf.FormId = 1027 ) AS src
    ON src.EventId = trg.EventId AND trg.FormId = 990
  WHEN NOT MATCHED THEN
    INSERT ( EventId, FormId, FormStatus, FormComplete ) 
    VALUES ( src.EventId, 990, 'C', 100 );
    -- Archive QoL-forms
  UPDATE dbo.ClinForm SET Archived = 1 WHERE FormId IN ( 897, 939 ) 
    AND EventId IN (SELECT EventId FROM dbo.ClinForm WHERE FormId = 1027 );
END
GO

GRANT EXECUTE ON [ROAS].[AfterPromScoring] TO [Administrator]
GO