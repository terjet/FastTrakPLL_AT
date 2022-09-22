SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[EnableFMForPatient] @PersonId INT AS
BEGIN
  -- Sjekk om det er medikamenter som ikke er sponert, og som ikke er fra FM
  IF EXISTS (SELECT 1
      FROM dbo.DrugTreatment dt
      WHERE dt.PersonId = @PersonId
      AND dt.StopAt IS NULL
      AND dt.FMLibId IS NULL)
  BEGIN
    RAISERROR ('Kan ikke aktivere e-resept for pasienter som har medikamenter som ikke er seponert!', 16, 1 );
    RETURN -1;
  END;
  UPDATE dbo.Person SET FMEnabled = 1 WHERE PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [eResept].[EnableFMForPatient] TO [FMUser]
GO