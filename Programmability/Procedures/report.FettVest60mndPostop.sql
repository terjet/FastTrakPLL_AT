SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FettVest60mndPostop] AS
BEGIN
  SELECT PersonId, ReverseName, GroupName, F589, F594, F651, F684 
  FROM
  ( 
    SELECT c.PersonId, c.ReverseName, v.GroupName,                              
      'F'+Cast(a.FormId AS VARCHAR) AS [FormId], 
     b.EventTime
    FROM dbo.ClinForm a
      JOIN dbo.ClinEvent b ON b.EventId = a.EventId 
      JOIN dbo.Person c ON c.PersonId = b.PersonId
      JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = b.PersonId
      JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudName = 'FettVest'                                                                                                                                                                
    WHERE a.FormId IN ( 589, 594, 651, 684 ) 
      AND a.DeletedBy IS NULL
  ) AS s
  PIVOT
  (
    MAX(EventTime)
    FOR [FormId] IN ( F589,F594,F651,F684)
  ) AS b
  ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [report].[FettVest60mndPostop] TO [FastTrak]
GO