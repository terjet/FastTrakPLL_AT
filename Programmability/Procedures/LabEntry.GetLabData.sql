SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LabEntry].[GetLabData] (@PersonId INT, @BatchId INT = NULL) AS
BEGIN
    SELECT lc.LabName, ld.*, p.Initials
    FROM dbo.LabData ld
    JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
    LEFT JOIN dbo.UserList ul ON ul.UserId = ld.SignedBy
    LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
    WHERE ld.PersonId = @PersonId
    AND ((ld.BatchId = @BatchId) OR (@BatchId IS NULL));
END;
GO