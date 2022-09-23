SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[NorGeP] AS
BEGIN

  SELECT dt.PersonId, ng.Id AS NorGeP, ISNULL( dt.Dose24hDD, 0 ) AS DpValue, dt.StartAt, dt.TreatId AS RowId
  FROM dbo.OngoingTreatment dt JOIN KB.NorGEP ng ON dt.ATC=ng.ATC 
  JOIN dbo.Person p ON p.PersonId=dt.PersonId   
  WHERE ( ( ng.MaxDose IS NULL ) OR ( ng.MaxDose < dt.Dose24HDD ) OR ( dt.Dose24hDD IS NULL ) ) 
  AND ( ( p.DOB < getdate()-365.25*ng.AgeLow ) AND ( p.DOB > getdate()-365.24*ng.AgeHigh ) )                                                                 

  UNION

  SELECT a.PersonId, ng.NgId, a.AlertLevel, a.CreatedAt, a.AlertId
  FROM dbo.Alert a 
  JOIN KB.InteractionNorGEP ng ON ng.AlertClass=a.AlertClass
  JOIN KB.NorGEP n ON n.Id=ng.NgId
  JOIN dbo.KbInteraction i ON i.IntId=ng.IntId
  WHERE a.AlertLevel > 0
  
  UNION

  SELECT PersonId, 36, DrugCount, GETDATE(), PersonId
  FROM KB.ViewNorGEPPoly
  ORDER BY PersonId, NorGeP;
END;
GO

GRANT EXECUTE ON [report].[NorGeP] TO [FastTrak]
GO