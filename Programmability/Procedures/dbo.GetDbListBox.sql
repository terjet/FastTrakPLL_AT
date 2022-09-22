SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDbListBox]( @StudyId INT, @ListId VARCHAR(8)) AS
BEGIN
  SELECT ProcDesc,RTRIM(ProcName + ' ' + ISNULL(ProcParams,' ')) AS [SqlText]
    FROM DbProcList l 
  JOIN Study s ON s.StudyName=l.StudyName OR l.StudyName='*'    
  WHERE (ListId=@ListId) AND (ISNULL(s.StudyId,0)=0 or s.StudyId=@StudyId)     
  ORDER BY ProcDesc
END
GO

GRANT EXECUTE ON [dbo].[GetDbListBox] TO [FastTrak]
GO