SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetProfessions] AS
BEGIN
  -- Retrieves a list of professions a user can choose from.
  SELECT ProfId, ProfName, NULL AS InfoText, ProfType 
  FROM AccessCtrl.UserProfession
  ORDER BY ProfName;
END
GO

GRANT EXECUTE ON [dbo].[GetProfessions] TO [FastTrak]
GO