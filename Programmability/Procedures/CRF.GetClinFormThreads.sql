SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetClinFormThreads]( @ClinFormId INT )
AS
BEGIN
  SELECT ct.ThreadId,ct.ThreadName,mt.FixedThreads 
  FROM ClinForm cf  
  JOIN ClinEvent ce ON ce.EventId=cf.EventId
  JOIN MetaForm mf ON mf.FormId=cf.FormId 
  JOIN MetaThreadType mt ON mt.V = mf.ThreadTypeId
  JOIN ClinThread ct ON ct.StudyId=ce.StudyId AND ct.PersonId=ce.PersonId AND ct.ThreadTypeId=mf.ThreadTypeId
  WHERE cf.ClinFormId=@ClinFormId
  
  UNION 
  
  SELECT 0,NewThreadName,FixedThreads 
  FROM ClinForm cf
  JOIN MetaForm mf ON mf.FormId=cf.FormId 
  JOIN MetaThreadType mt ON mt.V = mf.ThreadTypeId 
  WHERE cf.ClinFormId=@ClinFormId AND mt.FixedThreads=0
  
  ORDER BY ct.ThreadId
END
GO

GRANT EXECUTE ON [CRF].[GetClinFormThreads] TO [FastTrak]
GO