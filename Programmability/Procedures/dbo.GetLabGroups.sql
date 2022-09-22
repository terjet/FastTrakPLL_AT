SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabGroups] AS
BEGIN
  SELECT LabGroupId, LabGroupName, SortOrder, CreatedAt, CreatedBy
  FROM dbo.LabGroup
  ORDER BY SortOrder, LabGroupId
END
GO