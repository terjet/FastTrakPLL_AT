SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[GetLabDateMultitestTable]( @LabClassId INT, @MinCount INT )
RETURNS @DateTable 
TABLE ( PersonId INT NOT NULL, DateString VARCHAR(10) NOT NULL, LabCount INT NOT NULL, FirstTest DateTime, LastTest DateTime ) AS
BEGIN
  INSERT INTO @DateTable 
    SELECT PersonId, CONVERT( VARCHAR, LabDate, 102 ), COUNT(*), MIN(LabDate), MAX(LabDate)
    FROM dbo.LabData ld 
    JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
    JOIN dbo.LabClass lcl ON lcl.LabClassId = lc.LabClassId
    WHERE lcl.LabClassId = @LabClassId
    GROUP BY PersonId,CONVERT(VARCHAR,LabDate,102)
    HAVING COUNT(*) >= @MinCount
  RETURN;
END
GO