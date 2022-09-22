SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLivingStatus]( @NationalId VARCHAR(16), @DeceasedDate DateTime, @DeceasedInd BIT )
AS
BEGIN
  UPDATE dbo.Person SET DeceasedInd = @DeceasedInd, DeceasedDate = @DeceasedDate WHERE NationalId = @NationalId;
  UPDATE dbo.LivingStatusCheck SET LastChecked = GETDATE() WHERE NationalId=@NationalId;
  -- If nothing affected, insert row for check
  IF @@ROWCOUNT = 0
    INSERT INTO LivingStatusCheck( NationalId, LastChecked ) VALUES( @NationalId, GETDATE() )
END
GO

GRANT EXECUTE ON [dbo].[UpdateLivingStatus] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateLivingStatus] TO [ReadOnly]
GO