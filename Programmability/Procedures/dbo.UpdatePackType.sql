SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePackType]( @TreatId INT, @PackType CHAR )
AS
BEGIN
  UPDATE DrugTreatment SET PackType = @PackType WHERE TreatId=@TreatId;
  IF @@ROWCOUNT = 1
    SELECT 1,'Update OK'
  ELSE
    SELECT -1,'Update failed';
END
GO

GRANT EXECUTE ON [dbo].[UpdatePackType] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdatePackType] TO [ReadOnly]
GO