SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[CanSignClinForm]( @ClinFormId INT )
AS
BEGIN
  DECLARE @CanSign INT;
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @SignedByName VARCHAR(255);
  DECLARE @IsSigned INT;

  SET @CanSign = 1;
  SET @IsSigned = 0;

  -- Is it already signed?
  SELECT @IsSigned = 1, @SignedByName = ISNULL( p.FullName, '(ukjent bruker)' )
  FROM   dbo.ClinForm cf
  LEFT JOIN dbo.UserList ul ON ul.UserId = cf.SignedBy
  LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
  WHERE  ClinFormId = @ClinFormId AND FormStatus = 'L';

  IF @IsSigned = 1
    BEGIN
      SET @CanSign = -1;
      SET @ErrMsg = 'Skjema er allerede signert av ' + @SignedByName + '!';
    END
  ELSE IF dbo.HasSignClinFormPrivilege( @ClinFormId, NULL ) = 0
    BEGIN
      SET @CanSign = -2;
      SET @ErrMsg = 'Du har ikke rettigheter til å signere dette skjemaet!';
    END
  ELSE
    BEGIN
      SET @CanSign = 1;
      SET @ErrMsg = '';
    END
  SELECT @CanSign AS CanSign, @ErrMsg AS ErrMsg;
END
GO

GRANT EXECUTE ON [CRF].[CanSignClinForm] TO [FastTrak]
GO