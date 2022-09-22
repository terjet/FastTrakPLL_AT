SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LabEntry].[GetLabClasses] AS
BEGIN
    SELECT *
    FROM dbo.LabClass lc
	WHERE ( NOT NLK IS NULL)
    AND ( (GETDATE() >= lc.ValidFrom ) OR ( lc.ValidFrom IS NULL) )
    AND ( (GETDATE() < lc.ValidUntil ) OR ( lc.ValidUntil IS NULL) );
END;
GO