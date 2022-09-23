SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RapportDokumentasjonsfrekvens]
AS
BEGIN
  SELECT ul.UserId,p.ReverseName, LastThreeMonths.CountLastThreeMonths, LastMonth.CountLastMonth, LastWeek.CountLastWeek, mp.ProfName
    FROM (
      SELECT ul1.UserId, COUNT(*) CountLastThreeMonths
        FROM dbo.ClinForm cf
        JOIN dbo.UserList ul1 ON ul1.UserId = cf.CreatedBy
        JOIN dbo.UserList ul2 ON ul2.CenterId = ul1.CenterId AND ul2.UserId = USER_ID()
        WHERE cf.CreatedAt > DATEADD(MONTH, -3, GETDATE())
        GROUP BY ul1.UserId) LastThreeMonths
    LEFT JOIN (
      SELECT ul1.UserId, COUNT(*) CountLastMonth
        FROM dbo.ClinForm cf
        JOIN dbo.UserList ul1 ON ul1.UserId = cf.CreatedBy
        JOIN dbo.UserList ul2 ON ul2.CenterId = ul1.CenterId AND ul2.UserId = USER_ID()
        WHERE cf.CreatedAt > DATEADD(MONTH, -1, GETDATE())
        GROUP BY ul1.UserId) LastMonth ON LastMonth.UserId = LastThreeMonths.UserId
    LEFT OUTER JOIN (
      SELECT ul1.UserId, COUNT(*) CountLastWeek
        FROM dbo.ClinForm cf
        JOIN dbo.UserList ul1 ON ul1.UserId = cf.CreatedBy
        JOIN dbo.UserList ul2 ON ul2.CenterId = ul1.CenterId AND ul2.UserId = USER_ID()
        WHERE cf.CreatedAt > DATEADD(DAY, -7, GETDATE())
        GROUP BY ul1.UserId) LastWeek ON LastWeek.UserId = LastThreeMonths.UserId
    JOIN dbo.UserList ul ON ul.UserId = LastThreeMonths.UserId
    JOIN dbo.Person p ON p.PersonId = ul.PersonId
    LEFT JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId
    WHERE ul.UserId > 0
    ORDER BY LastThreeMonths.CountLastThreeMonths DESC;
END
GO

GRANT EXECUTE ON [dbo].[RapportDokumentasjonsfrekvens] TO [superuser]
GO