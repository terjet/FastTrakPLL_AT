SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetActiveProfessions] AS
BEGIN
  -- Retrieves a list of professions that can be given to a user.
  -- The order and selection of fields is used to match the PickList dialog.
  SELECT ProfId, ProfName, NULL AS InfoText, ProfType
  FROM dbo.MetaProfession 
  WHERE DisabledBy IS NULL
  ORDER BY ProfName;
END;
GO