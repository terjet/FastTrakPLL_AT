SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetProblemGroups]( @ListId INTEGER ) AS
BEGIN
  IF @ListId = 4 
  BEGIN
    SELECT mi.ItemCode,mi.ItemName FROM dbo.MetaNomItem mi
    JOIN dbo.MetaNomListItem li ON li.ItemId=mi.ItemId and ListId IN (16,17)
  END      
  ELSE
    SELECT '*' as ItemCode, ListName as ItemName FROM dbo.MetaNomList WHERE ListId=@ListId;
END
GO

GRANT EXECUTE ON [dbo].[GetProblemGroups] TO [FastTrak]
GO