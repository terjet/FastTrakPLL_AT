SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[GetLabSeriesTable]( @LabClassId INT, @HourSpan INT, @MinCount INT = 2 ) 
RETURNS  @ResultTable 
TABLE ( PersonId INT NOT NULL, TestNo INT NOT NULL, FirstTest DateTime NOT NULL, LabDate DateTime NOT NULL, NumResult FLOAT NULL ) AS
BEGIN
  INSERT INTO @ResultTable 
  SELECT idate.PersonId, RANK() OVER ( PARTITION BY idate.PersonId ORDER BY LabDate ) AS TestNo, 
    idate.FirstTest, ld.LabDate, ld.NumResult 
  FROM Report.GetLabDateMultitestTable( @LabClassId, @MinCount ) idate
  JOIN dbo.LabData ld ON ld.PersonId = idate.PersonId AND ld.LabDate >= idate.FirstTest
  JOIN dbo.LabCode lc ON lc.LabCodeId=ld.LabCodeId 
  JOIN dbo.LabClass lcl ON lcl.LabClassId=lc.LabClassId AND lcl.LabClassId = @LabClassId
  WHERE DATEDIFF(HOUR,FirstTest,LabDate) <= @HourSpan
  ORDER BY idate.PersonId, ld.LabDate;
  RETURN;
END
GO