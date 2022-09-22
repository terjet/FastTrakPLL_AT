SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastLabDataTable]( @LabClassId INT, @CutoffTime DateTime ) 
RETURNS @LabDataTable TABLE ( 
  PersonId INT NOT NULL PRIMARY KEY,
  LabDate DateTime NOT NULL,
  LabName VARCHAR(40) NOT NULL,
  NumResult FLOAT NOT NULL ) AS
BEGIN
  INSERT @LabDataTable
  SELECT PersonId, LabDate, LabName, NumResult
  FROM (SELECT ld.PersonId, ld.LabDate, lc.LabName, ld.NumResult, RANK()
    OVER (
      PARTITION BY ld.PersonId
        ORDER BY ld.LabDate DESC, ResultId DESC ) AS OrderNo
      FROM dbo.LabData ld
      JOIN dbo.LabCode lc 
        ON lc.LabCodeId=ld.LabCodeId
      WHERE lc.LabClassId = @LabClassId AND ld.LabDate < @CutoffTime
      AND ISNULL(ld.NumResult, -1) >= 0) a
    WHERE OrderNo = 1; 
  RETURN;
END
GO

GRANT SELECT ON [dbo].[GetLastLabDataTable] TO [QuickStat]
GO