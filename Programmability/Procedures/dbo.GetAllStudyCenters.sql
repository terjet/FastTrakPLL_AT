SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetAllStudyCenters] AS
BEGIN
  SELECT CenterId, CenterName 
  FROM dbo.StudyCenter
  ORDER BY CenterId;
END
GO

GRANT EXECUTE ON [dbo].[GetAllStudyCenters] TO [Support]
GO