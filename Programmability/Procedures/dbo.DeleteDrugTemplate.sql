SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugTemplate]( @FriendlyName varchar(64) )
AS
BEGIN
  DELETE FROM dbo.DrugTemplate WHERE FriendlyName=@FriendlyName
END
GO

GRANT EXECUTE ON [dbo].[DeleteDrugTemplate] TO [FastTrak]
GO