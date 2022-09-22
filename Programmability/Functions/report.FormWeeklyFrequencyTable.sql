SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[FormWeeklyFrequencyTable]( @FormName VARCHAR(24) ) 
RETURNS @FormTable TABLE ( TimeAxis DateTime NOT NULL, CenterId INT NOT NULL, n INT NOT NULL, FormComplete INT NOT NULL ) AS
BEGIN
  INSERT INTO @FormTable
  SELECT TimeAxis, CenterId, COUNT(*) AS n, AVG(FormComplete) AS FormComplete
  FROM 
  (
    SELECT DATEADD( WEEK, DATEDIFF( WEEK, 0, cf.CreatedAt), 0 ) AS TimeAxis, sg.CenterId, cf.FormComplete
    FROM dbo.ClinForm cf
    JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId
    JOIN dbo.StudyGroup sg ON sg.StudyId=ce.StudyId AND sg.GroupId = ce.GroupId
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
    WHERE mf.FormName = @FormName
  ) Forms
  GROUP BY TimeAxis, CenterId;
  RETURN;
END
GO