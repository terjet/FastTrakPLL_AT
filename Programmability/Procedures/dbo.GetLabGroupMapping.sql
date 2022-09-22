SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabGroupMapping] AS
BEGIN
  SELECT lg.SortOrder, lg.LabGroupId, lg.LabGroupName, lc.LabCodeId, lc.LabName, lc.VarName, lc.UnitStr
  FROM dbo.LabGroup lg
  LEFT OUTER JOIN dbo.LabCodeGroup lcg ON lcg.LabGroupId = lg.LabGroupId
  LEFT OUTER JOIN dbo.LabCode lc ON lc.LabCodeId = lcg.LabCodeId
  ORDER BY lg.SortOrder, lc.LabName, lc.UnitStr
END
GO