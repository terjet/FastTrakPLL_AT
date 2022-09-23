SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNoFormBeslutninger] (@StudyId INT) AS
BEGIN
    EXEC dbo.GetCaseListLastForm @StudyId, 'GBD_BESLUTNINGER', 36500;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoFormBeslutninger] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoFormBeslutninger] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoFormBeslutninger] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoFormBeslutninger] TO [Vernepleier]
GO