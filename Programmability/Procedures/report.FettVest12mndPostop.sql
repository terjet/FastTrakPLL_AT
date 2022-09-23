SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FettVest12mndPostop] AS
BEGIN
  SELECT PersonId, ReverseName, GroupName, F587, F592, F650, F681, F682, F709 
  FROM
  ( 
    SELECT p.PersonId, p.ReverseName, v.GroupName,
      'F'+CAST(cf.FormId AS VARCHAR) AS [FormId], 
      ce.EventTime
    FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId          
      JOIN dbo.Person p ON p.PersonId = ce.PersonId         
      JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = p.PersonId              
      JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudName = 'FettVest'
    WHERE cf.FormId IN ( 587, 592, 650, 681, 682, 709 )     
      AND cf.DeletedBy IS NULL
  ) AS s
  PIVOT
  (  
    MAX( EventTime )  
    FOR [FormId] IN ( F587, F592, F650, F681, F682, F709 )
  ) AS b  
  ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [report].[FettVest12mndPostop] TO [FastTrak]
GO