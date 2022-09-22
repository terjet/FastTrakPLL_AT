SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RuleDrugInteractions] ( @StudyId INT, @PersonId INT ) AS
  /* Variables for interaction result */
  DECLARE @LevelId tinyint;
  DECLARE @ATC1 varchar(7);
  DECLARE @ATC2 varchar(7);
  DECLARE @Drug1 varchar(64);
  DECLARE @Drug2 varchar(64);
  DECLARE @InfoText varchar(512);
  DECLARE @AlertLevel tinyint;
  /* Variables for message */
  DECLARE @AlertAction varchar(4);
  DECLARE @AlertClass varchar(12);
  DECLARE @AlertInfo varchar(32);
  DECLARE @AlertFacet varchar(16);
  DECLARE @AlertHeader varchar(64);
  DECLARE @IntId integer;
BEGIN
  /* Downgrade old alerts */
  UPDATE Alert SET AlertLevel=0 WHERE StudyId=@StudyId AND PersonId=@PersonId AND AlertClass LIKE 'DRUID#%';
  CREATE TABLE #ATCList (AtcFragment varchar(7) COLLATE Danish_Norwegian_CI_AS NOT NULL);
  /* Build ATC list */
  INSERT INTO #ATCList (ATCFragment) SELECT ATC FROM DrugTreatment WHERE PersonId=@PersonId AND ( ( StopAt > GetDate() OR StopAt IS NULL ) AND PauseStatus=0 )
  INSERT INTO #ATCList (ATCFragment) SELECT DISTINCT SUBSTRING(ATCFragment,1,5) FROM #ATCList;
  INSERT INTO #ATCList (ATCFragment) SELECT DISTINCT SUBSTRING(ATCFragment,1,4) FROM #ATCList;
  INSERT INTO #ATCList (ATCFragment) SELECT DISTINCT SUBSTRING(ATCFragment,1,3) FROM #ATCList
  INSERT INTO #ATCList (ATCFragment) SELECT GrpCode FROM KBMetaMember WHERE GrpMember IN ( SELECT ATCFragment FROM #ATCList);
  /* Find matching interactions */
  DECLARE interaction_cursor CURSOR FOR
  SELECT i.IntId,i.LevelId,i.ATC1,dt1.AtcName as Drug1,i.ATC2,dt2.AtcName as Drug2,i.InfoText
  FROM KBInteraction i
    JOIN KBAtcIndex dt1 ON i.ATC1=dt1.AtcCode
    JOIN KBAtcIndex dt2 ON i.ATC2=dt2.AtcCode
  WHERE ATC1 IN (SELECT DISTINCT ATCFragment FROM #ATCList ) AND ATC2 IN (SELECT DISTINCT ATCFragment FROM #ATCList )
  ORDER BY i.LevelId DESC;
  /* Add alerts for interactions */
  OPEN interaction_cursor;
  FETCH NEXT FROM interaction_cursor INTO @IntId,@LevelId,@ATC1,@Drug1,@ATC2,@Drug2,@InfoText;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @AlertClass='DRUID#'+CONVERT(VARCHAR,@IntId)
    SET @Alertheader=@Drug1 + ' - ' + @Drug2;
    /* Map levels and facets */
    SELECT @AlertLevel = CASE @LevelId
      WHEN 1 THEN 1
      WHEN 2 THEN 2
      WHEN 3 THEN 2
      WHEN 4 THEN 4
    END;
    SELECT @AlertInfo = CASE @LevelId
      WHEN 1 THEN 'Mulig interaksjon: '
      WHEN 2 THEN 'Ta forholdsregler: '
      WHEN 3 THEN 'Ta med 2-3 timers intervall: '
      WHEN 4 THEN 'Må ikke kombineres: '
    END
    SELECT @AlertFacet = CASE @LevelId
      WHEN 1 THEN 'RiskLow'
      WHEN 2 THEN 'RiskMedium'
      WHEN 3 THEN 'RiskMedium'
      WHEN 4 THEN 'RiskHigh'
    END
    SELECT @AlertAction = CASE @LevelId
      WHEN 1 THEN 'TFYM'
      WHEN 2 THEN 'TYM'
      WHEN 3 THEN 'TYM'
      WHEN 4 THEN 'TM'
    END
    SET @InfoText = @AlertInfo + @InfoText;
    EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,@AlertClass,@AlertFacet,@AlertHeader,@InfoText,@AlertAction;
    FETCH NEXT FROM interaction_cursor INTO @IntId,@LevelId,@ATC1,@Drug1,@ATC2,@Drug2,@InfoText;
  END
  CLOSE interaction_cursor
  DEALLOCATE interaction_cursor;
END;
GO

GRANT EXECUTE ON [dbo].[RuleDrugInteractions] TO [FastTrak]
GO