SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[InfectionReport]( @StartAt DateTime = NULL, @StopAt DateTime = NULL )
AS
BEGIN
  SET LANGUAGE Norwegian;
  IF @StartAt IS NULL SET @StartAt = getdate()-90;
  IF @StopAt IS NULL SET @StopAt = getdate();
  SELECT ce.PersonId,ce.EventId,ce.EventTime,
    dbo.MonthYear( ce.EventTime) as MonthName,
    c.CenterId,c.CenterName,
    sg.GroupId,sg.GroupName,
    mia1.OptionText as InfeksjonsType,
    mia7.OptionText as KjentAgens, 
    co6.TextVal as Agens,
    mia8.OptionText as GittMedisin,        
    co9.TextVal as MedisinNavn,
    co2.DTVal as StartDato,co3.DTVal as SluttDato,
    mia4.OptionText as SykehusInnleggelse, mia5.OptionText as [PasientDøde],
    ul.UserId,up.PersonId as UserPersonId,up.ReverseName as Brukernavn
  INTO #temp
  FROM ClinEvent ce 
  JOIN ClinForm cf ON cf.EventId=ce.EventId AND cf.DeletedAt IS NULL 
  JOIN MetaForm mf ON mf.FormId=cf.FormId AND mf.FormName='GBD_INFECTION'
  LEFT OUTER JOIN ClinObservation co1 ON co1.EventId=ce.EventId AND co1.VarName='INFECT_TYPE'
  LEFT OUTER JOIN MetaItemAnswer mia1 ON mia1.ItemId=769 and mia1.OrderNumber=co1.EnumVal
  LEFT OUTER JOIN ClinObservation co2 ON co2.EventId=ce.EventId AND co2.VarName='INFECT_DATE_START'
  LEFT OUTER JOIN ClinObservation co3 ON co3.EventId=ce.EventId AND co3.VarName='INFECT_DATE_END'
  LEFT OUTER JOIN ClinObservation co4 ON co4.EventId=ce.EventId AND co4.VarName='INFEKSJON_INNLEGGELSE'
  LEFT OUTER JOIN MetaItemAnswer mia4 ON mia4.ItemId=777 and mia4.OrderNumber=co4.EnumVal
  LEFT OUTER JOIN ClinObservation co5 ON co5.EventId=ce.EventId AND co5.VarName='INFEKSJON_DØD'
  LEFT OUTER JOIN MetaItemAnswer mia5 ON mia5.ItemId=778 and mia5.OrderNumber=co5.EnumVal
  LEFT OUTER JOIN ClinObservation co6 ON co6.EventId=ce.EventId AND co6.VarName='INFECT_AGENT_NAMES'
  LEFT OUTER JOIN ClinObservation co7 ON co7.EventId=ce.EventId AND co7.VarName='INFECT_AGENT_KNOWN'
  LEFT OUTER JOIN MetaItemAnswer mia7 ON mia7.ItemId=3498 and mia7.OrderNumber=co7.EnumVal
  LEFT OUTER JOIN ClinObservation co8 ON co8.EventId=ce.EventId AND co8.VarName='INFECT_DRUG_GIVEN'
  LEFT OUTER JOIN MetaItemAnswer mia8 ON mia8.ItemId=3499 and mia8.OrderNumber=co8.EnumVal
  LEFT OUTER JOIN ClinObservation co9 ON co9.EventId=ce.EventId AND co9.VarName='INFECT_DRUG_NAMES'
  JOIN UserList ul ON ul.UserId=cf.CreatedBy
  JOIN UserList my ON my.UserId=USER_ID()
  JOIN Person up ON up.PersonId=ul.PersonId
  JOIN StudCase sc ON sc.StudyId=ce.StudyId AND sc.PersonId=ce.PersonId
  JOIN Study s ON s.StudyId=sc.StudyId AND s.StudyName='GBD'
  JOIN StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId
  JOIN StudyCenter c ON c.CenterId=sg.CenterId AND c.CenterId=my.CenterId
  LEFT OUTER JOIN StudyUser su ON su.UserId=USER_ID() AND su.StudyId=sc.StudyId
  WHERE ( ce.EventTime > @StartAt AND ce.EventTime < @StopAt )
  AND (( su.GroupId=sc.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ));
  SELECT * FROM #temp ORDER BY EventTime;
END

GRANT EXECUTE ON GBD.InfectionReport to public
GO