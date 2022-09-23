SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleReminder]( @StudyId INT, @PersonId INT )
AS
BEGIN
  -- Reset all alerts of this class to level 0, because some forms may have been deleted
  UPDATE dbo.Alert SET AlertLevel = 0 WHERE StudyId = @StudyId AND PersonId = @PersonId AND AlertClass LIKE 'CF#%';
  
  -- Find events first to get a small temp table for next join
  SELECT ce.EventId, cf.ClinFormId, ce.EventTime 
  INTO #tempEvents 
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'ALERT'
  WHERE ce.StudyId = @StudyId AND ce.PersonId = @PersonId; 
  
  -- Get current alerts 
  SELECT @PersonId as PersonId,@StudyId AS StudyId,
    'CF#' + CONVERT(VARCHAR,te.ClinFormId) AS AlertClass,
    'Include' AS AlertFacet,                                                          
    c.EnumVal AS AlertLevel,
    h.TextVal AS AlertHeader, 
    q.TextVal + ' ( <a href="ShowClinFormId='+CONVERT(VARCHAR,te.ClinFormId) + '">Påminnelse</a> fra ' + CONVERT(VARCHAR,te.EventTime,104 ) + ' )' AS AlertMessage,
    ISNULL(NULLIF(b.TextVal,''),'TWMF') AS AlertButtons, 
    d.DTVal AS HideUntil           
  INTO #tempAlerts
  FROM #tempEvents te 
    JOIN dbo.ClinDataPoint h on h.EventId = te.EventId AND h.ItemId = 5601 
    JOIN dbo.ClinDataPoint c on c.EventId = te.EventId AND c.ItemId = 5603 
    JOIN dbo.ClinDataPoint q on q.EventId = te.EventId AND q.ItemId = 5602
    JOIN dbo.ClinDataPoint d ON d.EventId = te.EventId AND d.ItemId = 5604
    LEFT OUTER JOIN dbo.ClinDataPoint b ON b.EventId = te.EventId AND b.ItemId = 5605
  WHERE c.EnumVal > 0;
    
  UPDATE dbo.Alert SET 
    AlertLevel = t.AlertLevel, AlertHeader = t.AlertHeader,
    AlertMessage = t.AlertMessage, AlertButtons = UPPER(t.AlertButtons)
  FROM #tempAlerts t 
  WHERE ( t.PersonId = Alert.PersonId AND t.StudyId = Alert.StudyId AND t.AlertClass = Alert.AlertClass )
  AND  (Alert.AlertLevel <> t.AlertLevel OR Alert.AlertMessage <> t.AlertMessage OR Alert.AlertHeader <> t.AlertHeader OR Alert.AlertButtons <> t.AlertButtons);
  
  -- Bump forward HideUntil if needed (data on form has changed)  
  UPDATE dbo.Alert 
  SET HideUntil = t.HideUntil
  FROM #tempAlerts t
  WHERE (t.PersonId = Alert.PersonId AND t.StudyId = Alert.StudyId AND t.AlertClass = Alert.AlertClass )
  AND t.HideUntil > Alert.HideUntil;
  
  -- Remove all existing alerts from temp, based on ClinFormId
  DELETE FROM #tempAlerts WHERE AlertClass IN ( SELECT AlertClass FROM dbo.Alert WHERE StudyId=@StudyId AND PersonId=@PersonId );
  
  -- Add the rest, which will be from new ClinForms
  INSERT INTO dbo.Alert ( PersonId,StudyId,AlertClass,AlertFacet,AlertLevel,AlertHeader,AlertMessage,AlertButtons,HideUntil)
  SELECT t.PersonId,t.StudyId,t.AlertClass,t.AlertFacet,t.AlertLevel,t.AlertHeader,t.AlertMessage,t.AlertButtons,t.HideUntil 
  FROM #tempAlerts t;
  
END
GO

GRANT EXECUTE ON [GBD].[RuleReminder] TO [FastTrak]
GO