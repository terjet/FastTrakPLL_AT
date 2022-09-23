SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[GetFMBrukerInfo] AS
BEGIN
  SELECT 
    ul.UserId, p.DOB, p.FstName, p.MidName, p.LstName, p.GenderId, p.NationalId, 'Norsk' AS Nasjonalitet, 
    ul.FmUserName, ul.FmPassword, 
    mp.ProfName AS [Role], 'Enabled' AS [Status]
  FROM dbo.UserList ul
    JOIN dbo.Person p ON p.PersonId = ul.PersonId
    JOIN dbo.MetaProfession mp ON ul.ProfId = mp.ProfId
  WHERE ul.UserId = USER_ID();
END
GO

GRANT EXECUTE ON [eResept].[GetFMBrukerInfo] TO [FastTrak]
GO