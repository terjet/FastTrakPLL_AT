SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[UpdateNewMessageWarning]( @NationalId VARCHAR(16), @NewMsgCount INT )
AS
BEGIN
  UPDATE Comm.NewMessageWarning SET NewMsgCount = @NewMsgCount, LastUpdated = getdate() 
  WHERE PersonId IN ( SELECT PersonId FROM dbo.Person WHERE NationalId = @NationalId );
  IF @@ROWCOUNT = 0
    INSERT INTO Comm.NewMessageWarning ( PersonId, NewMsgCount, LastUpdated )
    SELECT PersonId,@NewMsgCount,getdate() FROM dbo.Person WHERE NationalId = @NationalId;
END
GO

GRANT EXECUTE ON [Comm].[UpdateNewMessageWarning] TO [FastTrak]
GO

DENY EXECUTE ON [Comm].[UpdateNewMessageWarning] TO [ReadOnly]
GO