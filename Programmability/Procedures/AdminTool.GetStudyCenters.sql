SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetStudyCenters] ( @ExcludeDisabled TINYINT = 0 ) AS
BEGIN
	SELECT *
	FROM dbo.StudyCenter
	WHERE ( CenterActive = 1 OR @ExcludeDisabled = 0 );
END;
GO