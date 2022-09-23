SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleLokaliseringsteknologi] (@StudyId INT, @PersonId INT) AS
BEGIN
    DECLARE @FormName VARCHAR(24) = 'GbdGps';
    DECLARE @FormTitle VARCHAR(128) = dbo.GetMetaFormTitle(@StudyId, @FormName);
    DECLARE @DTVal DATETIME = dbo.GetLastDTValOnForm(@FormName, 1957, @PersonId, 1);

    DECLARE @ScopeName VARCHAR(12) = 'EvalDate';
    DECLARE @AlertHdr VARCHAR(64);
    DECLARE @AlertMsg VARCHAR(512);

    DECLARE @AlertFacet VARCHAR(16) = 'DataFound';
    DECLARE @AlertLevel INT = 0;

    IF (@DTVal IS NOT NULL)
        AND (@DTVal < CONVERT(DATE, GETDATE()))
    BEGIN
        SET @AlertFacet = 'DataOld';
        SET @AlertLevel = 2;

        -- Get Header & Message for specified scope & facet
        EXEC dbo.GetAlertText @ScopeName, @AlertFacet, @AlertHdr OUT, @AlertMsg OUT;

        SET @AlertMsg = REPLACE(@AlertMsg, '@EvalueringDate', CONVERT(VARCHAR, @DTVal, 104));
        SET @AlertMsg = REPLACE(@AlertMsg, '@FormTitle', CONVERT(VARCHAR, @FormTitle));
        SET @AlertMsg = REPLACE(@AlertMsg, '@FormName', CONVERT(VARCHAR, @FormName));

        SET @AlertHdr = @FormTitle;
    END
    ELSE
    BEGIN
        EXEC dbo.GetAlertText @ScopeName, @AlertFacet, @AlertHdr OUT, @AlertMsg OUT;
    END

    EXEC dbo.AddAlertForPerson @StudyId,
        @PersonId,
        @AlertLevel,
        'GPSEVALUERIN',
        @AlertFacet,
        @AlertHdr,
        @AlertMsg;
END
GO

GRANT EXECUTE ON [GBD].[RuleLokaliseringsteknologi] TO [FastTrak]
GO