SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinThreadLockRow]( @RowId INT ) AS
  UPDATE dbo.ClinThreadData SET Locked=1,LockedAt=GetDate(),LockedBy=USER_ID()
  WHERE RowId=@RowId AND Locked=0;
  IF @@ROWCOUNT=1
    PRINT 'The row was successfully locked'
  ELSE BEGIN
    PRINT 'The row could not be locked';
    RAISERROR( 'Row %d could not be locked',1,16,@RowId );
  END
GO

GRANT EXECUTE ON [CRF].[UpdateClinThreadLockRow] TO [FastTrak]
GO