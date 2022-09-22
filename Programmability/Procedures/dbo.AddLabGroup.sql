SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddLabGroup]( @LabGroupName VARCHAR(40) ) AS
BEGIN
  DECLARE @MaxSort INT;
  DECLARE @LabGroupId INT;
  SELECT @LabGroupId = LabGroupId
  FROM dbo.LabGroup
  WHERE LabGroupName = @LabGroupName;
  IF NOT @LabGroupId IS NULL
    SELECT LabGroupId, LabGroupName, SortOrder, CreatedAt, CreatedBy FROM dbo.LabGroup
    WHERE LabGroupName = @LabGroupName
  ELSE
  BEGIN
    SELECT @MaxSort = ISNULL(MAX(SortOrder), 0) FROM dbo.LabGroup;
    INSERT INTO dbo.LabGroup(LabGroupName, SortOrder) VALUES (@LabGroupName, @MaxSort + 1);
    SELECT SCOPE_IDENTITY() AS LabGroupId, @LabGroupName AS LabGroupName, @MaxSort + 1 AS SortOrder, GETDATE() AS CreatedAt, USER_ID() AS CreatedBy;
  END
END
GO

GRANT EXECUTE ON [dbo].[AddLabGroup] TO [superuser]
GO