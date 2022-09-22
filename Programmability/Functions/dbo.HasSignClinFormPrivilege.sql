SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[HasSignClinFormPrivilege](@ClinFormId INT,@UserId INT = NULL)
RETURNS INT
AS
  BEGIN
    DECLARE @NeedsPrivilegeResult INT;
    DECLARE @HasSignPrivilege INT;

    SET @UserId = ISNULL(@UserId, USER_ID());
    SET @NeedsPrivilegeResult = dbo.NeedsFormPrivilege(@ClinFormId);
    SET @HasSignPrivilege = 0;

    IF @NeedsPrivilegeResult = 0
      RETURN 1;

    SELECT @HasSignPrivilege = CanSign
    FROM   dbo.MetaFormProfessionPrivilege a
    JOIN   dbo.ClinForm b
      ON b.FormId = a.FormId
    JOIN   dbo.MetaProfession d
      ON d.ProfType = a.ProfType
    JOIN   dbo.UserList e
      ON e.ProfId = d.ProfId
    WHERE  e.UserId = @UserId AND b.ClinFormId = @ClinFormId;

    RETURN @HasSignPrivilege;
  END
GO