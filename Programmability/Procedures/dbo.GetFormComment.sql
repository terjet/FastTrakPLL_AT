SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetFormComment]( @EventId INT,@FormId INT )
AS
BEGIN
  SET NOCOUNT ON; 
  SELECT Comment,MemoHeight,FormStatus,FormComplete FROM dbo.ClinForm 
  WHERE EventId=@EventId AND FormId=@FormId
END
GO