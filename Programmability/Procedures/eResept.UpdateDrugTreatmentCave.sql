SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- eResept.UpdateDrugTreatmentCave ================================================================

CREATE PROCEDURE [eResept].[UpdateDrugTreatmentCave]( @PersonId INT ) AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @GrunnlagForCaveTab TABLE ( TreatId INT, CaveIdList VARCHAR(MAX), CaveText VARCHAR(MAX) );

  INSERT INTO @GrunnlagForCaveTab
    SELECT TreatId, CaveIdList,  'Grunnlag: '
    FROM dbo.DrugTreatment
    WHERE PersonId = @PersonId;

  DECLARE @BR VARCHAR(2) = CHAR(13) + CHAR(10);

  DECLARE @TreatId INT;
  DECLARE @GrunnlagForCAVE VARCHAR(MAX) = 'Grunnlag: ';

  DECLARE treat_cur CURSOR FAST_FORWARD FOR
  SELECT gc.TreatId, CONCAT( dr.ReaksjonDN, ', ', ISNULL(dr.DescriptiveText, '(ingen ytterligere detaljer)'), '. '  )
  FROM dbo.DrugReaction dr
    JOIN @GrunnlagForCaveTab gc ON CHARINDEX( dr.CaveId, gc.CaveIdList ) > 0
  WHERE dr.PersonId = @PersonId;

  OPEN treat_cur;
  FETCH NEXT FROM treat_cur INTO @TreatId, @GrunnlagForCAVE;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    UPDATE @GrunnlagForCaveTab
    SET CaveText = CaveText + @BR + @GrunnlagForCAVE
    WHERE TreatId = @TreatId;
    FETCH NEXT FROM treat_cur INTO @TreatId, @GrunnlagForCAVE;
  END;

  CLOSE treat_cur;
  DEALLOCATE treat_cur;

  MERGE
  INTO dbo.DrugTreatment AS Trg USING @GrunnlagForCaveTab AS Src
  ON ( Trg.TreatId = Src.TreatId )
  WHEN MATCHED
    THEN UPDATE
      SET Trg.CAVE = Src.CaveText;

END
GO