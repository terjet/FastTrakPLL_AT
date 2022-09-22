SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[UpdatePullStatus]( @OutId INT, @StatusCode INT, @StatusMessage TEXT ) AS
BEGIN
  UPDATE COMM.OutBox SET PulledBy = USER_ID(),PulledAt=getdate(),StatusCode=@StatusCode, StatusMessage = @StatusMessage
  WHERE OutId=@OutId; 
END
GO