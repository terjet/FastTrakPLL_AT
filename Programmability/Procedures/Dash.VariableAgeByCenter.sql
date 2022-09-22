SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[VariableAgeByCenter]( @StudyId INT, @VarName VARCHAR(24), @StatusDate DateTime, @AgeIfNull FLOAT = 365.0 ) AS
BEGIN
  DECLARE @QIName VARCHAR(64);
  SET @QIName = @VarName + '.AGE';
  SELECT sg.CenterId,sc.StatusDate,
    COUNT(sc.PersonId) AS nActive,
    COUNT(pd.QIName) AS nFound,
    AVG(ISNULL(QIValue,@AgeIfNull)) as AvgValue
  FROM Dash.CaseListHistory sc
  JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId
  JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.StatusId  
  LEFT OUTER JOIN Dash.PersonData pd ON pd.StudyId=sc.StudyId AND pd.PersonId=sc.PersonId AND pd.StatusDate=sc.StatusDate AND pd.QIName=@QIName 
  WHERE sc.StudyId=@StudyId AND ss.StatusActive=1 AND sg.GroupActive=1 AND sc.StatusDate=@StatusDate
  GROUP BY sg.CenterId,sc.StatusDate
  ORDER BY sg.CenterId,sc.StatusDate
END
GO

GRANT EXECUTE ON [Dash].[VariableAgeByCenter] TO [FastTrak]
GO