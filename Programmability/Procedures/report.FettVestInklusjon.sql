SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FettVestInklusjon] AS
BEGIN
  SELECT PersonId, ReverseName, GroupName, F579, F590, F595, F606, F613, F616, F621, F628, F604, F620 
  FROM 
  ( SELECT ce.PersonId, p.ReverseName, v.GroupName,
      CONCAT( 'F', cf.FormId ) AS [FormId], 
      ce.EventTime
    FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId 
      JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ce.PersonId
      JOIN dbo.Person p ON p.PersonId = v.PersonId
      JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudName = 'FettVest'                                                                                                                                                                          
     WHERE cf.FormId IN ( 579, 590, 595, 606, 613, 616, 621, 628, 604, 620 )
       AND cf.DeletedBy IS NULL
  ) AS s
  PIVOT
  (
  MAX(EventTime)
  FOR [FormId] IN ( F579, F590, F595, F606, F613, F616, F621, F628, F604, F620)
  ) AS b
  ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [report].[FettVestInklusjon] TO [FastTrak]
GO