SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EnableRelation]( @RelId INT ) AS
BEGIN
  UPDATE MetaRelation SET DisabledAt = NULL, DisabledBy = NULL WHERE RelId=@RelId
END
GO

GRANT EXECUTE ON [dbo].[EnableRelation] TO [superuser]
GO