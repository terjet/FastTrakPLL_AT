SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FettVest3mndPostop] AS
BEGIN
  SELECT PersonId, ReverseName, GroupName, F591, F627, F652 
  FROM
  ( 
    SELECT v.PersonId, p.ReverseName, v.GroupName,                            
      'F'+CAST(cf.FormId AS VARCHAR) AS [FormId], 
      ce.EventTime
    FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId 
      JOIN dbo.Person p ON p.PersonId = ce.PersonId
      JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ce.PersonId
      JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudName = 'FettVest'                                                                                                                                                             
    WHERE cf.FormId IN ( 591, 627, 652) 
     AND cf.DeletedBy IS NULL
  ) AS s
  PIVOT
  (
    MAX(EventTime)
    FOR [FormId] IN ( F591, F627, F652 )
  ) AS b
  ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [report].[FettVest3mndPostop] TO [FastTrak]
GO