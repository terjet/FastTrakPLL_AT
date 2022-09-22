SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[UpdateMessageAppRec]( @OriginalMsgId uniqueidentifier, @StatusCode INTEGER, @AppRecMessage NVARCHAR(MAX) )
AS
BEGIN
  DECLARE @OutId INT;
  SELECT @OutId = OutId FROM Comm.OutBox WHERE MsgGuid = @OriginalMsgId;
  IF @OutId IS NULL
  BEGIN
    RAISERROR( 'The OriginalMsgId is unknown', 16, 1 )
    RETURN -1
  END;
  UPDATE Comm.Outbox SET StatusCode = @StatusCode, AppRecMessage = @AppRecMessage
  WHERE OutId=@OutId;
END
GO

GRANT EXECUTE ON [Comm].[UpdateMessageAppRec] TO [FastTrak]
GO

DENY EXECUTE ON [Comm].[UpdateMessageAppRec] TO [ReadOnly]
GO