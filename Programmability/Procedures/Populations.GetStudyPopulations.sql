SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Populations].[GetStudyPopulations]( @StudyId INT, @DbVer INT = NULL, @CheckExecute BIT = 1 ) AS
BEGIN
	SET NOCOUNT ON;
	IF @DbVer IS NULL SET @DbVer = dbo.DbVersion();
	SELECT * FROM Populations.StudyPopulations sp
	JOIN dbo.Study s ON s.StudyName = sp.StudyName OR sp.StudyName = '*'
	WHERE ( s.StudyId = @StudyId ) AND ( sp.DisabledAt IS NULL )
	-- Filter by database version
	AND ( ISNULL(sp.MinVersion, @DbVer) <= @DbVer )
	AND ( ISNULL(sp.MaxVersion, @DbVer) >= @DbVer )
	-- Filter by permissions granted if @CheckExecute = 1
	AND ( ( HAS_PERMS_BY_NAME( sp.ProcName, 'OBJECT', 'EXECUTE' ) = 1 ) OR ( @CheckExecute = 0 ) )
	ORDER BY ProcId;
END;
GO