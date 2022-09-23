SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetFormClassInPeriod]( @StudyId INT, @FormName VARCHAR(24),  @StartDate DateTime, @StopDate DateTime ) AS
BEGIN
   SELECT 
     v.PersonId, v.DOB, v.FullName, v.GroupName, 'n = ' + CONVERT(VARCHAR,agg.Antall) AS InfoText 
  FROM 
    (
      SELECT ce.PersonId,COUNT(*) as Antall 
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId AND cf.DeletedAt IS NULL
      JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId 
      WHERE mf.FormName = @FormName
      AND ce.EventTime BETWEEN @StartDate AND @StopDate
      GROUP BY ce.PersonId
     ) agg
  JOIN dbo.ViewCaseListStub v ON agg.PersonId=v.PersonId
  WHERE v.StudyId=@StudyId;
END
GO

GRANT EXECUTE ON [dbo].[GetFormClassInPeriod] TO [FastTrak]
GO