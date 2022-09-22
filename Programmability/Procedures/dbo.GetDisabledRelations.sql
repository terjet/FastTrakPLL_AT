SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDisabledRelations] AS
BEGIN
  SELECT mr.RelId, CONCAT( mr.RelName, ' - ', mr.RelDuration, ' d' ), mr.RelDuration, mp.ProfName
  FROM dbo.MetaRelation mr JOIN MetaProfession mp ON mp.ProfType=mr.ProfType 
  WHERE mr.DisabledBy<>0 
  ORDER BY mp.ProfName,mr.RelName
END
GO