SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetYoungDiabetics]( @StudyId INT ) AS
BEGIN
  SELECT a.*, a.StudyName + ': '+ CONVERT( VARCHAR,a.FirstDate,104) + ' (' + CONVERT(VARCHAR,a.Alder) + ' år)'  AS InfoText
  FROM (
    SELECT p.PersonId,p.DOB,p.FullName,dt.OptionText AS GroupName,p.GenderId,p.NationalId,
      DATEDIFF(YYYY,p.DOB,sc.CreatedAt ) AS Alder, sc.CreatedAt AS FirstDate, s.StudyName,
      RANK() OVER( PARTITION BY p.PersonId ORDER BY sc.CreatedAt ) AS EntryOrder
    FROM dbo.Person p
      JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId
      JOIN dbo.Study s ON s.StudyId=sc.StudyId
      JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) dt ON dt.PersonId = p.PersonId 
    WHERE DATEDIFF(YYYY,p.DOB,sc.CreatedAt) BETWEEN 15 AND 20
  AND s.StudName IN ( 'NDV','ENDO' )
  ) a
  WHERE a.EntryOrder = 1
  ORDER BY Alder
END
GO

GRANT EXECUTE ON [NDV].[GetYoungDiabetics] TO [FastTrak]
GO