SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[AddRequest]( @PersonId INT, @FormId INT, @PromUid VARCHAR(36), @FormOrderId VARCHAR(36) ) AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO PROM.FormOrder (PersonId, FormId, PromUid, FormOrderId) VALUES (@PersonId, @FormId, @PromUid, @FormOrderId);
END
GO