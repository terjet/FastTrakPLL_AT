SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPopularListItems]( @ListId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT TOP 50 i.ItemCode,i.ItemName,li.Popularity FROM
    MetaNomItem i JOIN dbo.MetaNomListItem li on li.ItemId=i.ItemId
  WHERE li.ListId=@ListId AND Popularity > 0
  ORDER BY Popularity desc
END;
GO

GRANT EXECUTE ON [dbo].[GetPopularListItems] TO [FastTrak]
GO