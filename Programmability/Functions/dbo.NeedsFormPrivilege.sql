SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NeedsFormPrivilege](@ClinFormId INT)
RETURNS INT
AS
  BEGIN
    DECLARE @NeedsPrivilege INT;

    SET @NeedsPrivilege = 0;

    SELECT @NeedsPrivilege = 1
    FROM   dbo.ClinForm cf
    JOIN   dbo.MetaFormProfessionPrivilege mf
      ON mf.FormId = cf.FormId
    WHERE  cf.ClinFormId = @ClinFormId;
    RETURN @NeedsPrivilege;
  END
GO

GRANT EXECUTE ON [dbo].[NeedsFormPrivilege] TO [FastTrak]
GO