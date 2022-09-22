SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[VariableAgePivot]( @VarName VARCHAR(64) ) AS
BEGIN
  DECLARE @QIName VARCHAR(64);
  SET @QIName = @VarName + '.AGE';
  SELECT StatusDate,[2],[4],[5],[6],[7],[8],[9],[10]
  FROM 
    ( 
    SELECT sg.CenterId,sc.StatusDate,ISNULL(pd.QIValue,365) as AvgValue365 
    FROM Dash.CaseListHistory sc
    LEFT OUTER JOIN Dash.PersonData pd ON sc.StudyId=pd.StudyId AND sc.PersonId=pd.PersonId 
    AND sc.StatusDate=pd.StatusDate AND pd.QIName=@QIName                             
    JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.GroupActive=1
    JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.StatusId AND ss.StatusActive=1
    WHERE sc.StudyId=2
    )
  AS SourceTable
    PIVOT( AVG(AvgValue365) FOR CenterId IN ([2],[4],[5],[6],[7],[8],[9],[10]) )
  AS PivotTable
END
GO