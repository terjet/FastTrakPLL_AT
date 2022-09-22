SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [GBD].[HultenNursingLoadByGroup]
AS
  SELECT v.GroupName, 
    MIN( dbo.GetLastQuantity( v.PersonId, 'HULTEN_SCORE' )) as MinHulten,
    AVG( dbo.GetLastQuantity( v.PersonId, 'HULTEN_SCORE' )) as AvgHulten,
    MAX( dbo.GetLastQuantity( v.PersonId, 'HULTEN_SCORE' )) as MaxHulten
  FROM ViewActiveCaseListStub v
  JOIN Study s ON s.StudyId=v.StudyId AND s.StudyName='GBD'
  GROUP BY v.GroupName
GO

GRANT SELECT ON [GBD].[HultenNursingLoadByGroup] TO [FastTrak]
GO