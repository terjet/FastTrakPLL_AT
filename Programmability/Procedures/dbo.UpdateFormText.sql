SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateFormText] ( @EventId INT, @FormId INT, @CachedText VARCHAR(MAX) ) AS
BEGIN
  UPDATE dbo.ClinForm SET CachedText=@CachedText 
  WHERE ( FormId=@FormId ) AND ( EventId=@EventId ) AND ( ISNULL(CachedText,'') <> ISNULL(@CachedText,'') );
END
GO