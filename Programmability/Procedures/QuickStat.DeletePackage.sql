﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [QuickStat].[DeletePackage]( @PackId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM report.QuickStat WHERE RowId = @PackId;
END
GO