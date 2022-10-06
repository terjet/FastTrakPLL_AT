SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [BDR].[LipidTable]( @StartDate DATETIME, @StopDate DATETIME )
RETURNS @LabTable TABLE( PersonId INT NOT NULL, LabClassId INT, NumResult FLOAT ) AS
BEGIN
  INSERT @LabTable SELECT Subquery.PersonId, Subquery.LabClassId, Subquery.NumResult FROM
    ( SELECT ld.PersonId, lcode.LabClassId, ld.NumResult, ROW_NUMBER() OVER ( PARTITION BY ld.PersonId, lcode.LabClassId ORDER BY ld.LabDate DESC ) AS ReverseOrder
      FROM dbo.LabData ld
    JOIN dbo.LabCode lcode ON lcode.LabCodeId = ld.LabCodeId
    JOIN dbo.LabClass lclass ON lclass.LabClassId = lcode.LabClassId
    WHERE lclass.LabClassId IN (34, 35, 36, 37) AND ( ld.LabDate >= @StartDate AND ld.LabDate < DATEADD(DAY, 1, @StopDate) )
    ) Subquery
  WHERE Subquery.ReverseOrder = 1;
  RETURN;
END
GO

GRANT SELECT ON [BDR].[LipidTable] TO [Administrator]
GO