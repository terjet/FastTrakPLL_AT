SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugsStudy]( @StudyId INT, @ATC VARCHAR(7) = NULL )
AS
BEGIN
  SELECT dt.PersonId,dt.StartAt,dt.ATC,dt.DrugName,dt.Strength
  FROM DrugTreatment dt
  JOIN StudCase sc on sc.PersonId=dt.PersonId AND sc.StudyId=@StudyId
  WHERE ( @ATC IS NULL ) OR ( dt.ATC LIKE @ATC )
END;
GO