SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddPopulationLog] ( @StudyId INT, @ProcId INT, @ProcDesc VARCHAR(64), @MsElapsed DECIMAL(9,2) )
AS
BEGIN
  INSERT INTO dbo.PopulationLog( StudyId, ProcId, ProcDesc, MsElapsed ) 
  VALUES ( @StudyId, @ProcId, @ProcDesc, @MsElapsed );
END;
GO