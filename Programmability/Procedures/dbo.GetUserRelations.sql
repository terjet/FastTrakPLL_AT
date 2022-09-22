SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetUserRelations] ( @UserId INT = NULL ) 
AS
BEGIN
  IF @UserId IS NULL SET @UserId = USER_ID();
  SELECT mr.RelId,mr.RelName FROM MetaRelation mr  
    JOIN MetaProfession mp on mp.ProfType=mr.ProfType
    JOIN UserList ul ON ul.ProfId=mp.ProfId 
  WHERE ul.UserId=@UserId AND mr.DisabledBy IS NULL
END
GO