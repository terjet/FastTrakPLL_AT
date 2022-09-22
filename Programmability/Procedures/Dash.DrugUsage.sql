SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[DrugUsage]( @StudyId INT, @AtcMatch VARCHAR(16), @CenterId INT )
AS
BEGIN
  DECLARE @QIName VARCHAR(64);
  SET @QIName = @ATCMatch + '.USE';
  SELECT sc.StudyId,sg.CenterId,sc.StatusDate,
    COUNT(sc.PersonId) AS nActive,
    COUNT(pd.QIName) AS nFound,
    100.0*AVG(QIValue) as AvgValue
  FROM Dash.CaseListHistory sc  
  JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId
  JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.StatusId
  LEFT OUTER JOIN Dash.PersonData pd ON pd.StudyId=sc.StudyId AND pd.PersonId=sc.PersonId AND pd.StatusDate=sc.StatusDate 
  WHERE sc.StudyId=@StudyId AND sg.CenterId=@CenterId AND sg.GroupActive=1 AND ss.StatusActive=1 AND QIName=@QIName
  GROUP BY sc.StudyId,sg.CenterId,sc.StatusDate                                            
  HAVING COUNT(sc.PersonId) > 20
  ORDER BY sc.StatusDate
END
GO

GRANT EXECUTE ON [Dash].[DrugUsage] TO [FastTrak]
GO