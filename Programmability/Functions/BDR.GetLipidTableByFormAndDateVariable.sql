SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [BDR].[GetLipidTableByFormAndDateVariable]( @FormName VARCHAR(MAX), @DateVariable INT )
  RETURNS @LabTable TABLE(PersonId INT, LabClassId INT, NumResult FLOAT, LabDate DATETIME) AS
BEGIN
  INSERT @LabTable SELECT Subquery.PersonId, Subquery.LabClassId, Subquery.NumResult, Subquery.LabDate FROM
    (
      SELECT form.PersonId, lcode.LabClassId, ld.NumResult, ld.LabDate, ROW_NUMBER() OVER ( PARTITION BY ld.PersonId, lcode.LabClassId ORDER BY ld.LabDate DESC ) AS ReverseOrder
        FROM dbo.GetLastFormTableByName( @FormName, NULL ) form
      LEFT JOIN dbo.ClinDataPoint BloodSampleDate ON BloodSampleDate.EventId = form.EventId AND BloodSampleDate.ItemId = @DateVariable 
      JOIN dbo.LabData ld ON ld.PersonId = form.PersonId AND CONVERT(DATE, ld.LabDate) = CONVERT(DATE, BloodSampleDate.DTVal)
      JOIN dbo.LabCode lcode ON lcode.LabCodeId = ld.LabCodeId
      JOIN dbo.LabClass lclass ON lclass.LabClassId = lcode.LabClassId
      WHERE lclass.LabClassId IN (34, 35, 36, 37)
     ) Subquery
  WHERE Subquery.ReverseOrder = 1;
  RETURN;
END;
GO