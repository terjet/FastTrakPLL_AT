SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[UpdateExposure]( @ContactGuid uniqueidentifier, @FirstExposure DateTime, @LastExposure DateTime, @ExposureCodes VARCHAR(32), @ExposureText VARCHAR(MAX) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE Pandemic.Contact SET FirstExposure = @FirstExposure, LastExposure = @LastExposure, ExposureCodes = @ExposureCodes, ExposureType = @ExposureText
  WHERE ContactGuid = @ContactGuid;
END
GO