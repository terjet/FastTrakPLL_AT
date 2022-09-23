SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPregnantInPeriod]( @StudyId INT, @StartDate DateTime, @StopDate DateTime ) AS
BEGIN
   SELECT 
     v.PersonId, v.DOB, v.FullName, v.GroupName, v.GenderId, p.NationalId, 
     REPLACE(ISNULL(mia.OptionText, 'Uspesifisert'),'.','') + '; ' + CONVERT(VARCHAR,agg.Antall) + ' kontroller.' AS InfoText 
  FROM 
    (
      SELECT ce.PersonId,COUNT(*) AS Antall 
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
      JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId 
      WHERE mf.FormName = 'DIAPOL_GRAVIDE'
      AND ce.EventTime BETWEEN @StartDate AND @StopDate
      GROUP BY ce.PersonId
     ) agg
  JOIN dbo.ViewCaseListStub v ON agg.PersonId = v.PersonId
  JOIN dbo.Person p ON p.PersonId = v.PersonId
  LEFT JOIN dbo.MetaItemAnswer mia ON mia.ItemId = 3196 AND mia.OrderNumber = dbo.GetLastEnumValInThePast( v.PersonId, 'NDV_TYPE', @StopDate )
  WHERE v.StudyId = @StudyId;
END
GO

GRANT EXECUTE ON [NDV].[GetPregnantInPeriod] TO [FastTrak]
GO