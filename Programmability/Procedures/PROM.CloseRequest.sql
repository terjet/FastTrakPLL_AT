SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[CloseRequest]( @FormOrderId VARCHAR(36), @OrderStatus VARCHAR(16), @ClinFormId INT = NULL ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE PROM.FormOrder SET FormOrderId=@FormOrderId, OrderStatus = @OrderStatus, ClinFormId = NULLIF(@ClinFormId,0)
  WHERE FormOrderId = @FormOrderId
END;
GO