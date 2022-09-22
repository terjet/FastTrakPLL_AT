SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [NDV].[GetConsentSummaryTable] ( @StartTime DATETIME, @EndAt DATETIME )
RETURNS @ConsentSummary TABLE (
  StartTime DATETIME NOT NULL,
  EndAt DATETIME NOT NULL,
  ShortCode VARCHAR(3) NOT NULL,
  Antall INT
) AS
BEGIN
  INSERT @ConsentSummary
    SELECT @StartTime, @EndAt, ShortCode, COUNT(*) Ant
    FROM NDV.GetConsentStatusTable(@StartTime, @EndAt)
    GROUP BY ShortCode;
  RETURN;
END
GO

GRANT SELECT ON [NDV].[GetConsentSummaryTable] TO [FastTrak]
GO