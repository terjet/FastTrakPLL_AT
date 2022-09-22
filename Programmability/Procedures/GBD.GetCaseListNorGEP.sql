SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNorGEP]( @StudyId INT ) AS
BEGIN
 
  SELECT DISTINCT dt.PersonId,p.DOB,p.FullName,a.GroupName,dt.DrugName + ': ' + ng.Warning + ' (NorGEP ' + CONVERT(VARCHAR,ng.Id) + ')' AS InfoText,ng.Id  
  FROM DrugTreatment dt JOIN KB.NorGEP ng ON dt.ATC=ng.ATC 
    JOIN ViewActiveCaseListStub a ON a.PersonId=dt.PersonId AND StudyId=@StudyId
    JOIN Person p ON p.PersonId=a.PersonId   
  WHERE  ( ( dt.StopAt IS NULL ) OR ( dt.StopAt > getdate() ) ) 
    AND ( ( ng.MaxDose IS NULL ) OR ( ng.MaxDose < dt.Dose24HDD ) OR ( dt.Dose24hDD IS NULL ) )
    AND ( ( p.DOB < getdate()-365.25*AgeLow ) AND ( p.DOB > getdate()-365.24*AgeHigh ) )                                                                 

  UNION
  
  SELECT PersonId,DOB,FullName,GroupName, AlertHeader + ': ' + Warning + ' (NorGEP ' + CONVERT(VARCHAR,NgId) + ')' AS InfoText, ngId
  FROM KB.ViewNorGEPInteractions WHERE StudyId=@StudyId
  
  UNION
  
  SELECT a.PersonId, a.DOB, a.FullName, a.GroupName, n.Warning + '(NorGEP 36, n=' + CONVERT(VARCHAR,v.DrugCount) + ')' as InfoText,36 as Id FROM KB.ViewNorGEPPoly v 
  JOIN ViewActiveCaseListStub a ON a.PersonId=v.PersonId AND a.StudyId=@StudyId    
  JOIN KB.NorGEP n ON n.Id=36
  
  ORDER BY ng.Id
  
END
GO