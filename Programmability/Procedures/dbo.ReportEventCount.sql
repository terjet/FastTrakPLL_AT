SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportEventCount]
AS
BEGIN
  select datepart(yy,CreatedAt),datepart(mm,CreatedAt),count(*) FROM dbo.ClinEvent
  group by datepart(yy,CreatedAt),datepart(mm,CreatedAt)
  order by datepart(yy,CreatedAt),datepart(mm,CreatedAt);
END
GO