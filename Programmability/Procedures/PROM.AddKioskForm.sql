SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[AddKioskForm]( @FormOrderId VARCHAR(36), @ClinFormId INT, @FormTag VARCHAR(8) ) AS
BEGIN 
  SET NOCOUNT ON;
  INSERT INTO PROM.KioskForm( FormOrderId, ClinFormId, FormTag ) VALUES( @FormOrderId, @ClinFormId, @FormTag );
END;
GO