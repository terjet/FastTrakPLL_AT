SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DisableRelation]( @RelId INT ) AS
BEGIN
  UPDATE MetaRelation SET DisabledAt = getdate(), DisabledBy = USER_ID() WHERE RelId=@RelId;
  UPDATE ClinRelation SET ExpiresAt = getdate() WHERE RelId=@RelId AND ExpiresAt > getdate();
END
GO

GRANT EXECUTE ON [dbo].[DisableRelation] TO [superuser]
GO