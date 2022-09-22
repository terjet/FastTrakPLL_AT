SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Populations].[GetPopularPopulations]( @StudyId INT, @DbVer INT = NULL ) AS
BEGIN
  IF @DbVer IS NULL SET @DbVer = dbo.DbVersion();
  SELECT TOP 16 dpl.* FROM
   (
     SELECT ProcId,count(*) AS n
     FROM dbo.PopulationLog pl
     JOIN dbo.UserList ulthem ON ulthem.UserId = pl.CreatedBy
     JOIN dbo.UserList ulme ON ulme.ProfId = ulthem.ProfId 
     WHERE StudyId = @StudyId GROUP BY ProcId 
   ) a
  JOIN Populations.StudyPopulations dpl ON dpl.ProcId = a.ProcId
  WHERE (ISNULL(dpl.MinVersion, @DbVer) <= @DbVer)
  AND (ISNULL(dpl.MaxVersion, @DbVer) >= @DbVer)
  ORDER BY ProcId;
END;
GO

GRANT EXECUTE ON [Populations].[GetPopularPopulations] TO [FastTrak]
GO