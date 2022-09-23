SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetAnnualControlMissing](@StudyId INT)
AS
  BEGIN
    SET NOCOUNT ON;

    DECLARE @CutoffDate DateTime;
    SET @CutoffDate = DATEADD( MM, -15, GETDATE() );

    -- First get latest diabetes type
    SELECT a.PersonId,a.DiabetesType
    INTO   #DiaType
    FROM   (SELECT ce.PersonId,cdp.EnumVal AS DiabetesType,
              RANK() OVER ( PARTITION BY ce.PersonId ORDER BY ce.EventTime DESC ) AS OrderNo
              FROM   dbo.ClinEvent ce
              JOIN   dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId
            WHERE  cdp.ItemId = 3196) a
    WHERE  a.OrderNo = 1;

    -- Now get the list of patients
    SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,v.GenderId,p.NationalId, 'Type ' + mia.ShortCode AS InfoText
    FROM   (SELECT PersonId
              FROM   dbo.ViewActiveCaseListStub v
              WHERE  StudyId = @StudyId
            EXCEPT
              SELECT ce.PersonId
                FROM dbo.ClinEvent ce
                JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId
                JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'DIAPOL_YEAR'
              WHERE  ( cf.DeletedAt IS NULL ) AND ( ce.EventTime > @CutoffDate )) a
    JOIN   dbo.ViewActiveCaseListStub v
      ON v.PersonId = a.PersonId AND v.StudyId = @StudyId
    JOIN   dbo.Person p
      ON p.PersonId = v.PersonId
    JOIN   #DiaType dt
      ON dt.PersonId = v.PersonId
	JOIN dbo.MetaItemAnswer mia ON mia.ItemId=3196 AND mia.OrderNumber=dt.DiabetesType
  END
GO

GRANT EXECUTE ON [NDV].[GetAnnualControlMissing] TO [FastTrak]
GO