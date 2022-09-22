SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteLabGroup]( @LabGroupId INT ) AS
BEGIN
  DELETE FROM dbo.LabGroup
  WHERE LabGroupId = @LabGroupId;
END
GO