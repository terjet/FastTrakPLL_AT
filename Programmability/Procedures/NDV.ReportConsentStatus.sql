SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportConsentStatus] ( @StartTime DATETIME = NULL, @EndTime DATETIME = NULL, @PeriodType CHAR(8) = 'MONTH' ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT @StartTime = ISNULL(@StartTime, DATEADD(YEAR, -2, GETDATE()));
  SELECT @EndTime = ISNULL(@EndTime, GETDATE());
  CREATE TABLE #ResData (
    StartTime DATETIME NOT NULL PRIMARY KEY,
    EndTime DATETIME NOT NULL,
    Ja INT NULL,
    Nei INT NULL,
    Trukket INT,
    Ukjent INT,
    Ubesvart INT NULL
  );
  ALTER TABLE #ResData ADD Totalt AS (ISNULL(Ubesvart, 0) + ISNULL(Ja, 0) + ISNULL(Nei, 0) + ISNULL(Trukket, 0) + ISNULL(Ukjent, 0));
  ALTER TABLE #ResData ADD JaProsent AS 100.0 * Ja / (ISNULL(Ubesvart, 0) + ISNULL(Ja, 0) + ISNULL(Nei, 0) + ISNULL(Trukket, 0) + ISNULL(Ukjent, 0));
  ALTER TABLE #ResData ADD NeiProsent AS 100.0 * Nei / (ISNULL(Ubesvart, 0) + ISNULL(Ja, 0) + ISNULL(Nei, 0) + ISNULL(Trukket, 0) + ISNULL(Ukjent, 0));
  ALTER TABLE #ResData ADD TrukketProsent AS 100.0 * Trukket / (ISNULL(Ubesvart, 0) + ISNULL(Ja, 0) + ISNULL(Nei, 0) + ISNULL(Trukket, 0) + ISNULL(Ukjent, 0));
  ALTER TABLE #ResData ADD UkjentProsent AS 100.0 * Ukjent / (ISNULL(Ubesvart, 0) + ISNULL(Ja, 0) + ISNULL(Nei, 0) + ISNULL(Trukket, 0) + ISNULL(Ukjent, 0));
  ALTER TABLE #ResData ADD UbesvartProsent AS 100.0 * Ubesvart / (ISNULL(Ubesvart, 0) + ISNULL(Ja, 0) + ISNULL(Nei, 0) + ISNULL(Trukket, 0) + ISNULL(Ukjent, 0));
  INSERT INTO #ResData (StartTime, EndTime, Ubesvart, Ja, Nei, Trukket, Ukjent)
    SELECT ml.StartTime, ml.EndTime, (SELECT Antall
        FROM NDV.GetConsentSummaryTable(ml.StartTime, ml.EndTime)
        WHERE ShortCode = '?')
      AS Ubesvart, (SELECT Antall
        FROM NDV.GetConsentSummaryTable(ml.StartTime, ml.EndTime)
        WHERE ShortCode = 'J')
      AS Ja, (SELECT Antall
        FROM NDV.GetConsentSummaryTable(ml.StartTime, ml.EndTime)
        WHERE ShortCode = 'N')
      AS Nei, (SELECT Antall
        FROM NDV.GetConsentSummaryTable(ml.StartTime, ml.EndTime)
        WHERE ShortCode = 'T')
      AS Trukket, (SELECT Antall
        FROM NDV.GetConsentSummaryTable(ml.StartTime, ml.EndTime)
        WHERE ShortCode = 'U')
      AS Ukjent
    FROM Report.TimePeriods ml
    WHERE (ml.StartTime >= @StartTime) AND (ml.StartTime < @EndTime AND ml.PeriodType = @PeriodType)
  SELECT *
  FROM #ResData
  ORDER BY StartTime DESC;
END
GO