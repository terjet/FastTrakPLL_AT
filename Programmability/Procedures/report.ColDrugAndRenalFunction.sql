SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[ColDrugAndRenalFunction]( @DrugPattern VARCHAR(8), @GfrThreshold INT ) AS 
BEGIN
  SELECT rx.PersonId, 'GFR_ESTIMATED' AS VarName, lab.NumResult AS DpValue, lab.LabDate AS EventTime, rx.MaxTreatId AS TreatId 
  FROM 
  ( 
    SELECT PersonId, MAX(TreatId) AS MaxTreatId 
    FROM dbo.OngoingTreatment 
    WHERE ( ATC LIKE @DrugPattern ) 
    GROUP BY PersonId 
  ) rx 
  JOIN  
  (  
    SELECT ld.PersonId, ld.NumResult, ld.LabDate, ROW_NUMBER() OVER ( PARTITION BY ld.PersonId ORDER BY ld.LabDate DESC ) AS ReverseOrder
    FROM dbo.LabData ld 
    JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
    AND lc.LabClassId IN ( 50, 51, 52, 995, 1075 )
  ) lab ON lab.PersonId = rx.PersonId AND lab.ReverseOrder = 1
  WHERE lab.NumResult < @GfrThreshold;
END
GO

GRANT EXECUTE ON [report].[ColDrugAndRenalFunction] TO [QuickStat]
GO