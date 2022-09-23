SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FormEvents].[UpdateNameFromAdminForm]( @ClinFormId INT ) AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @PersonId INT;
  DECLARE @FirstName VARCHAR(32);
  DECLARE @LastName VARCHAR(32);

  SELECT @PersonId=p.PersonId, @FirstName = LTRIM(RTRIM( cdp1.TextVal )), @LastName = LTRIM(RTRIM( cdp2.TextVal ))
  FROM dbo.Person p
    JOIN dbo.ClinEvent ce ON ce.PersonId = p.PersonId
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId
    LEFT JOIN dbo.ClinDataPoint cdp1 on cdp1.EventId = cf.EventId AND cdp1.ItemId = 12261
    LEFT JOIN dbo.ClinDataPoint cdp2 on cdp2.EventId = cf.EventId AND cdp2.ItemId = 12262
  WHERE cf.ClinFormId = @ClinFormId;
  IF DATALENGTH( @FirstName ) > 1 
    UPDATE dbo.Person SET FstName = @FirstName WHERE PersonId = @PersonId;
  IF DATALENGTH( @LastName ) > 1 
    UPDATE dbo.Person SET LstName = @LastName WHERE PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [FormEvents].[UpdateNameFromAdminForm] TO [FastTrak]
GO