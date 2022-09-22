SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CheckScriptPermission] AS
BEGIN
  PRINT 'You have script permission because you can execute this procedure!'
END
GO