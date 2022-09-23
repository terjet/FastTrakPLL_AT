SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportPAID]( @StudyId INT ) AS 
BEGIN

  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  -- Convert old PAID forms
  
  BEGIN TRANSACTION;
  UPDATE dbo.ClinDataPoint SET ItemId = ItemId - 2502, Quantity = Quantity-1, EnumVal = EnumVal - 1
  WHERE ItemId BETWEEN 3960 AND 3979;
  UPDATE dbo.ClinDataPoint SET ItemId = 1478 WHERE ItemId = 3980;
  UPDATE dbo.ClinForm SET FormId = 906 WHERE FormId = 298;
  IF @@TRANCOUNT > 0 COMMIT TRANSACTION;
       
  
  -- Query all forms in new format

  SELECT

    ce.PersonId, v.FullName AS ReverseName,
    -- Sum is used as the key to join the rest
    ce.EventTime, csum.Quantity AS PAIDSUM,
    -- Get all 20 items
    cdp1.EnumVal AS PAID01,  cdp2.EnumVal AS PAID02,  cdp3.EnumVal AS PAID03,  cdp4.EnumVal AS PAID04,  cdp5.EnumVal AS PAID05,
    cdp6.EnumVal AS PAID06,  cdp7.EnumVal AS PAID07,  cdp8.EnumVal AS PAID08,  cdp9.EnumVal AS PAID09,  cdp10.EnumVal AS PAID10,
    cdp11.EnumVal AS PAID11, cdp12.EnumVal AS PAID12, cdp13.EnumVal AS PAID13, cdp14.EnumVal AS PAID14, cdp15.EnumVal AS PAID15,
    cdp16.EnumVal AS PAID16, cdp17.EnumVal AS PAID17, cdp18.EnumVal AS PAID18, cdp19.EnumVal AS PAID19, cdp20.EnumVal AS PAID20
  
  FROM dbo.ClinDataPoint csum
  JOIN dbo.ClinEvent ce ON ce.EventId = csum.EventId
  JOIN dbo.ViewCenterCaseListStub v ON v.PersonId = ce.PersonId
  
  JOIN dbo.ClinDatapoint cdp1 ON cdp1.EventId = csum.EventId AND cdp1.ItemId=1458
  JOIN dbo.ClinDatapoint cdp2 ON cdp2.EventId = csum.EventId AND cdp2.ItemId=1459
  JOIN dbo.ClinDatapoint cdp3 ON cdp3.EventId = csum.EventId AND cdp3.ItemId=1460
  JOIN dbo.ClinDatapoint cdp4 ON cdp4.EventId = csum.EventId AND cdp4.ItemId=1461
  JOIN dbo.ClinDatapoint cdp5 ON cdp5.EventId = csum.EventId AND cdp5.ItemId=1462
  JOIN dbo.ClinDatapoint cdp6 ON cdp6.EventId = csum.EventId AND cdp6.ItemId=1463
  JOIN dbo.ClinDatapoint cdp7 ON cdp7.EventId = csum.EventId AND cdp7.ItemId=1464
  JOIN dbo.ClinDatapoint cdp8 ON cdp8.EventId = csum.EventId AND cdp8.ItemId=1465
  JOIN dbo.ClinDatapoint cdp9 ON cdp9.EventId = csum.EventId AND cdp9.ItemId=1466
  JOIN dbo.ClinDatapoint cdp10 ON cdp10.EventId = csum.EventId AND cdp10.ItemId=1467
  JOIN dbo.ClinDatapoint cdp11 ON cdp11.EventId = csum.EventId AND cdp11.ItemId=1468
  JOIN dbo.ClinDatapoint cdp12 ON cdp12.EventId = csum.EventId AND cdp12.ItemId=1469
  JOIN dbo.ClinDatapoint cdp13 ON cdp13.EventId = csum.EventId AND cdp13.ItemId=1470
  JOIN dbo.ClinDatapoint cdp14 ON cdp14.EventId = csum.EventId AND cdp14.ItemId=1471
  JOIN dbo.ClinDatapoint cdp15 ON cdp15.EventId = csum.EventId AND cdp15.ItemId=1472
  JOIN dbo.ClinDatapoint cdp16 ON cdp16.EventId = csum.EventId AND cdp16.ItemId=1473
  JOIN dbo.ClinDatapoint cdp17 ON cdp17.EventId = csum.EventId AND cdp17.ItemId=1474
  JOIN dbo.ClinDatapoint cdp18 ON cdp18.EventId = csum.EventId AND cdp18.ItemId=1475
  JOIN dbo.ClinDatapoint cdp19 ON cdp19.EventId = csum.EventId AND cdp19.ItemId=1476
  JOIN dbo.ClinDatapoint cdp20 ON cdp20.EventId = csum.EventId AND cdp20.ItemId=1477

  WHERE csum.ItemId = 1478 AND v.StudyId = @StudyId
  ORDER BY ce.PersonId,ce.EventTime;

END
GO

GRANT EXECUTE ON [NDV].[ReportPAID] TO [FastTrak]
GO