SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[UpdateTrackingDetails]( @ContactGuid uniqueidentifier, @GSM VARCHAR(16), @EmailAddress VARCHAR(64), @BostedKommune VARCHAR(64), @TrackingResponsible VARCHAR(64) ) AS
BEGIN
  UPDATE Pandemic.Contact 
    SET GSM = @GSM, EmailAddress = @EmailAddress, BostedKommune = @BostedKommune, 
      TrackingResponsible = @TrackingResponsible
  WHERE ContactGuid = @ContactGuid;
END
GO