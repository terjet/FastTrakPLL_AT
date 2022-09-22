SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMyProfession]() RETURNS VARCHAR(3) AS
BEGIN
  DECLARE @RetVal VARCHAR(3);
  SELECT @RetVal = ProfType 
  FROM dbo.UserList ul 
    JOIN dbo.MetaProfession mp ON mp.ProfId=ul.ProfId
  WHERE ul.UserId=USER_ID();
  RETURN @RetVal;
END
GO