SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[ReportOutboxForms] AS
BEGIN
  SET NOCOUNT ON;
  SELECT OutId,PersonId,DOB,Initials,EventTime,FormTitle,StatusCode,StatusText,StatusMessage,
    ExportedAt 
  FROM Comm.OutboxForm WHERE StatusCode<>1  
  ORDER BY StatusCode,OutId;
END
GO

GRANT EXECUTE ON [Comm].[ReportOutboxForms] TO [FastTrak]
GO