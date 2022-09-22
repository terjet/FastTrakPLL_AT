SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetMyMetaForms]( @StudyId INT, @MyProfession INT = 0, @PersonId INT = 0 ) AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TestCase BIT = 0;

    IF @PersonId > 0
        SELECT @TestCase = TestCase
        FROM dbo.Person
        WHERE PersonId = @PersonId;

    DECLARE @PilotUser INT = (IS_MEMBER('pilotuser') + IS_MEMBER('db_owner'));

    IF @MyProfession = 1
    BEGIN
        SELECT msf.FormId
            , COUNT(cf.FormId) AS UsedTimes INTO #temp
        FROM CRF.MetaStudyForm msf
        JOIN dbo.ClinForm cf ON cf.FormId = msf.FormId
            AND cf.CreatedAt > GETDATE() - 365
        JOIN dbo.UserList ul ON ul.UserId = cf.CreatedBy
        JOIN dbo.UserList me ON me.ProfId = ul.ProfId
            AND me.UserId = USER_ID()
        WHERE (msf.StudyId = @StudyId)
        AND (msf.SurveyStatus != 'Design')
        AND ((msf.SurveyStatus = 'Open')
            OR (@TestCase = 1)
            OR ((@TestCase = 0)
                AND (msf.SurveyStatus = 'Test')
                AND (@PilotUser > 0)))
        GROUP BY msf.FormId;

        SELECT TOP 15 msf.*
        FROM CRF.MetaStudyForm msf
        JOIN #temp t ON t.FormId = msf.FormId
        WHERE (t.UsedTimes > 3)
        AND (msf.StudyId = @StudyId)
        ORDER BY UsedTimes DESC;
    END
    ELSE
    BEGIN
        SELECT msf.*
        FROM CRF.MetaStudyForm msf
        JOIN dbo.UserList ul ON ul.UserId = USER_ID()
        WHERE (msf.StudyId = @StudyId)
        AND (msf.SurveyStatus != 'Design')
        AND ((msf.SurveyStatus = 'Open')
            OR (@TestCase = 1)
            OR ((@TestCase = 0)
                AND (msf.SurveyStatus = 'Test')
                AND (@PilotUser > 0)))
        ORDER BY msf.FormId;
    END
END
GO

GRANT EXECUTE ON [CRF].[GetMyMetaForms] TO [FastTrak]
GO