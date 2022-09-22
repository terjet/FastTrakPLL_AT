SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[DeleteClinThread]( @ThreadId INT ) AS
BEGIN
  DECLARE @FixedThreads BIT;
  SELECT @FixedThreads = FixedThreads FROM MetaThreadType mt JOIN ClinThread ct ON ct.ThreadTypeId=mt.V WHERE ct.ThreadId=@ThreadId;
  IF @FixedThreads = 1
    RAISERROR( 'This is a fixed thread and can not be deleted.', 16, 1 )
  ELSE
  BEGIN          
    DECLARE @DataRowCount INT;
    SELECT @DataRowCount = COUNT(RowId) FROM ClinThreadData WHERE ThreadId=@ThreadId;
    IF @DataRowCount = 0 
      DELETE FROM ClinThread WHERE ThreadId=@ThreadId
    ELSE
      RAISERROR( 'This thread has data and can not be deleted.', 16, 1 );
  END
END
GO

GRANT EXECUTE ON [CRF].[DeleteClinThread] TO [FastTrak]
GO