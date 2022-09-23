SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NOM].[GetSkopList] (@StudyId INT, @SearchText VARCHAR(16))
AS
BEGIN
    EXEC NOM.GetNomListItems @StudyId = @StudyId, @SearchText = @SearchText, @NomListId = 27;
END;
GO

GRANT EXECUTE ON [NOM].[GetSkopList] TO [FastTrak]
GO