SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCAVE]( @PersonId INT )
AS
BEGIN
  SELECT CAVE,NB,Reservations,Allergies FROM dbo.Person WHERE PersonId=@PersonId
END
GO

GRANT EXECUTE ON [dbo].[GetCAVE] TO [FastTrak]
GO