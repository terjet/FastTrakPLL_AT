SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[GetFMBrukerInfo] AS
BEGIN
  SELECT ul.UserId AS Id, ul.FmUserName, ul.FmPassword, p.DOB,
    p.FstName, p.MidName, p.LstName, p.GenderId, 'Norsk' AS Nasjonalitet,
    p.NationalId, mp.ProfName AS Role, 'Enabled' AS Status
  FROM dbo.UserList ul
  JOIN dbo.Person p ON p.PersonId = ul.PersonId
  JOIN dbo.MetaProfession mp ON ul.ProfId = mp.ProfId
  WHERE ul.UserId = USER_ID();
END
GO

GRANT EXECUTE ON [eResept].[GetFMBrukerInfo] TO [FastTrak]
GO