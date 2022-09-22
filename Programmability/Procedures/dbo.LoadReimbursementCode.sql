SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LoadReimbursementCode]( @CodeId INT )
AS
BEGIN
  SELECT * FROM MetaReimbursementCode WHERE CodeId=@CodeId
END
GO