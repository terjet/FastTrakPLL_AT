SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[UpdateRequestStatus]( @FormOrderId VARCHAR(36), @ExpiryDate DateTime, @LoginUrl VARCHAR(255), @OTP VARCHAR(16), @OrderStatus VARCHAR(16), @NotificationChannel VARCHAR(32) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE PROM.FormOrder 
  SET ExpiryDate = @ExpiryDate, LoginUrl = @LoginUrl, OTP = @OTP, 
    OrderStatus = @OrderStatus, NotificationChannel = @NotificationChannel
  WHERE FormOrderId = @FormOrderId;
END
GO

GRANT EXECUTE ON [PROM].[UpdateRequestStatus] TO [FastTrak]
GO