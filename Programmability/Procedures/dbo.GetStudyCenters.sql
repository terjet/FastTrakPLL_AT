SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyCenters] AS
BEGIN
  SELECT * FROM dbo.MyStudyCenters
  ORDER BY CenterId;
END
GO

GRANT EXECUTE ON [dbo].[GetStudyCenters] TO [FastTrak]
GO