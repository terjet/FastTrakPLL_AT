SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMyFavoriteProblems]( @ListId INT ) AS
BEGIN
  SELECT TOP 24 i.ItemCode, i.ItemName, l.DxSystem, ' n = ' + CONVERT( VARCHAR, COUNT(*)) AS n
  FROM dbo.ClinProblem cp 
  JOIN dbo.MetaNomListItem li ON cp.ListItem=li.ListItem 
  JOIN dbo.MetaNomItem i ON i.ItemId=li.ItemId
  JOIN dbo.MetaNomList l ON l.ListId = li.ListId AND li.ListId=@ListId
  WHERE cp.CreatedAt > ( GETDATE() - 365 )
  GROUP BY i.ItemCode, i.ItemName, l.DxSystem
  ORDER BY COUNT(*) DESC, i.ItemCode;
END
GO

GRANT EXECUTE ON [dbo].[GetMyFavoriteProblems] TO [FastTrak]
GO