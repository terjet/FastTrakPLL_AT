SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FettVestFormDates] AS
BEGIN
  SELECT PersonId, ReverseName, GroupName, 
    F582, F587, F588, F590, F591, F592, F593, F594, 
    F606, F616, F627, F650, F651, F652, F681, F682, F683, F684, 
    F709, F801, F1028, F1205, F1206, F1207, F1208 
  FROM 
  ( 
    SELECT c.PersonId, c.ReverseName, v.GroupName,                                 
         'F'+Cast(a.FormId AS VARCHAR) AS [FormId], 
         CONVERT(VARCHAR,b.EventTime,4) AS EventTime
      FROM dbo.ClinForm a
          JOIN dbo.ClinEvent b ON b.EventId = a.EventId 
         JOIN dbo.Person c ON c.PersonId = b.PersonId
         JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = b.PersonId
         JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudName = 'FettVest'                                                                                                                                                             
     WHERE a.FormId IN 
     ( 
       582, 587, 588, 590, 591, 592, 593, 594, 
       606, 616, 627, 650, 651, 652, 681, 682, 683, 684, 
       709, 801, 1028, 1205, 1206, 1207, 1208 
     )
     AND a.DeletedAt IS NULL
  ) AS s
  PIVOT
  (
    MAX( EventTime )
    FOR [FormId] IN 
    ( 
      F582, F587, F588, F590, F591, F592, F593, F594, 
      F606, F616, F627, F650, F651, F652, F681, F682, F683, F684, 
      F709, F801, F1028, F1205, F1206, F1207, F1208 
    ) 
  ) AS b
  ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [report].[FettVestFormDates] TO [FastTrak]
GO