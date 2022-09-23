SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPregnantByYear]( @StudyId INT, @Year INT )
AS
BEGIN
  SELECT ce.PersonId,COUNT(*) as Antall 
  INTO #temp FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId AND cf.DeletedAt IS NULL
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId 
  WHERE mf.FormName = 'DIAPOL_GRAVIDE'
  AND DATEPART(yy,ce.EventTime) = @Year
  GROUP BY ce.PersonId;
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, REPLACE(ISNULL(mia.OptionText, 'Uspesifisert'),'.','') + '; ' + CONVERT(VARCHAR,t.Antall) + ' kontroller ' + CONVERT(VARCHAR,@Year) + '.' AS InfoText
  FROM dbo.ViewCaseListStub v 
  JOIN #temp t ON t.PersonId=v.PersonId
  LEFT JOIN dbo.MetaItemAnswer mia ON mia.ItemId = 3196 AND mia.OrderNumber = dbo.GetLastEnumValInThePast( v.PersonId, 'NDV_TYPE', CONVERT(VARCHAR(10), CAST(@Year+1 as VARCHAR)+'-01-01'))
  WHERE v.StudyId=@StudyId;
END
GO

GRANT EXECUTE ON [NDV].[GetPregnantByYear] TO [FastTrak]
GO