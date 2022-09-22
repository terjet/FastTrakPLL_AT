SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[AddMetaRelation] (@ProfType VARCHAR(3), @RelName VARCHAR(64), @RelDuration FLOAT)
AS
BEGIN
    IF NOT EXISTS ( SELECT 1 FROM dbo.MetaProfession WHERE ProfType = @ProfType) RETURN;
    IF EXISTS ( SELECT 1 FROM dbo.MetaRelation WHERE ProfType = @ProfType and RelName = @RelName) RETURN;
    INSERT INTO dbo.MetaRelation (ProfType,RelName,RelDuration) VALUES (@ProfType,@RelName,@RelDuration);
END
GO