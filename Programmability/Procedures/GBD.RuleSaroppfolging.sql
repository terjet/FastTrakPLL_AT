SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleSaroppfolging] (@StudyId INT, @PersonId INT) AS
BEGIN
    DECLARE @FormName VARCHAR(24);
    DECLARE @FormTitle VARCHAR(128);
    DECLARE @DTVal DATETIME;
    DECLARE @SignedAt DATETIME;

    /*    Look for new evaluation date in GbdSaarProsedyre or
        GbdSaarOppfolging. If variable 1384 in GbdSaarOppfolging
        equal 1, evaluation is stopped and Alert is hidden. */
    SELECT TOP (1) @SignedAt = cf.SignedAt
        , @FormTitle = mf.FormTitle
        , @DTVal = cdp.DTVal
    FROM dbo.ClinForm cf
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
    LEFT JOIN dbo.ClinDataPoint cdp ON cdp.EventId = cf.EventId
    LEFT JOIN dbo.MetaFormItem mfi ON mfi.ItemId = cdp.ItemId
        AND mfi.FormId = cf.FormId
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
    WHERE mf.FormName IN ('GbdSaarProsedyre', 'GbdSaarOppfolging')
    AND cf.FormStatus = 'L'
    AND (cdp.ItemId = 5834
        OR (mf.FormName = 'GbdSaarOppfolging'
                AND cdp.ItemId = 1384
                AND cdp.EnumVal = 1))
    AND ce.StudyId = @StudyId
    AND ce.PersonId = @PersonId
    ORDER BY ce.EventNum DESC, cf.ClinFormId DESC, cdp.ItemId

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

        EXEC dbo.GetAlertText @ScopeName,
        @AlertFacet,
        @AlertHdr OUT,
        @AlertMsg OUT;

        SELECT @FormName = FormName,
                @FormTitle = FormTitle
        FROM dbo.MetaForm
        WHERE FormName = 'GbdSaarOppfolging';

        SET @AlertMsg = REPLACE(@AlertMsg, '@EvalueringDate', CONVERT(VARCHAR, @DTVal, 104));
        SET @AlertMsg = REPLACE(@AlertMsg, '@FormTitle', CONVERT(VARCHAR, @FormTitle));
        SET @AlertMsg = REPLACE(@AlertMsg, '@FormName', CONVERT(VARCHAR, @FormName));
        SET @AlertMsg = REPLACE(@AlertMsg, '@SignedDate', CONVERT(VARCHAR, @SignedAt, 104));

        SET @AlertHdr = @FormTitle;
    END
    ELSE
    BEGIN
        EXEC dbo.GetAlertText @ScopeName,
        @AlertFacet,
        @AlertHdr OUT,
        @AlertMsg OUT;
    END

    EXEC dbo.AddAlertForPerson @StudyId
    , @PersonId
    , @AlertLevel
    , 'SAROPPFOLGIN'
    , @AlertFacet
    , @AlertHdr
    , @AlertMsg;
END
GO

GRANT EXECUTE ON [GBD].[RuleSaroppfolging] TO [FastTrak]
GO