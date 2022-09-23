SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FettVest24mndPostop] AS
BEGIN
  SELECT PersonId, ReverseName, GroupName, F588, F593, F683, F801 
  FROM
  ( 
    SELECT p.PersonId, p.ReverseName, v.GroupName,                         
      'F'+Cast(cf.FormId AS VARCHAR) AS [FormId], 
      ce.EventTime
    FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId 
      JOIN dbo.Person p ON p.PersonId = ce.PersonId
      JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = p.PersonId
      JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudName = 'FettVest'                                                                                                                                                                                            
    WHERE cf.FormId IN ( 588, 593, 683, 801 ) 
      AND cf.DeletedBy IS NULL
  ) AS s
  PIVOT
  (
    MAX(EventTime)
    FOR [FormId] IN ( F588,F593,F683,F801)
  ) AS b
  ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [report].[FettVest24mndPostop] TO [FastTrak]
GO