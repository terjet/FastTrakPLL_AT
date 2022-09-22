SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetSearchProcedures]( @StudyId INT ) AS
BEGIN
  SELECT mi.ItemId, d.ProcId, d.ProcName, d.ProcDesc 
  FROM dbo.DbProcList d 
  JOIN dbo.MetaItem mi ON mi.ProcId = d.ProcId WHERE d.ListId='NOM';
END
GO