SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetEnabledRelations] AS
BEGIN
  SELECT mr.RelId, CONCAT( mr.RelName, ' - ', mr.RelDuration, ' d' ), mr.RelDuration, mp.ProfName
  FROM dbo.MetaRelation mr 
  JOIN dbo.MetaProfession mp ON mp.ProfType=mr.ProfType 
  WHERE mr.DisabledBy IS NULL
  ORDER BY mp.ProfName, mr.RelName
END
GO