SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Populations].[StudyPopulations] AS
	  SELECT ProcId, ProcName, ProcParams, StudyName, HelpText, InfoCaption,
		CASE
			WHEN CHARINDEX(':', ProcDesc) > 0 THEN SUBSTRING(ProcDesc, 1, CHARINDEX(':', ProcDesc) - 1)
			ELSE ''
		END AS ProcGroup,
		LTRIM(SUBSTRING(ProcDesc, CHARINDEX(':', ProcDesc) + 1, 9999)) AS ProcTitle,
		ProcDesc,
		ProcSourceCode,
	    RTRIM(ProcName + ' ' + ISNULL(ProcParams, ' ')) AS SqlText,
		MinVersion, MaxVersion, DisabledAt
	FROM dbo.DbProcList WHERE ListId = 'CASE';
GO