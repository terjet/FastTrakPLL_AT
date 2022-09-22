SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetColumnCaptions]
AS
BEGIN
  SELECT VarSpec, Caption, isnull(ColWidth, 100) AS ColWidth
  FROM Report.ColumnCaption
END

GRANT EXECUTE ON Report.GetColumnCaptions TO [public] AS [dbo]
GO