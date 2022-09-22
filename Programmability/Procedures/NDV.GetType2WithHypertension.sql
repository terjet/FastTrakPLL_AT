SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetType2WithHypertension]( @StudyId INT, @MinAge FLOAT = 60.0 ) AS
BEGIN
  SELECT *,
    CONVERT( INT, dbo.GetLastQuantity( PersonId,'SYSBP')) AS SYSBP,
    CONVERT( INT,dbo.GetLastQuantity( PersonId,'DIABP')) AS DIABP,
    CONVERT( INT, dbo.GetLastQuantity( PersonId,'NDV_BPDRUGS')) AS BPDRUGS 
  INTO #temp
  FROM NDV.Type2  
  WHERE Age > @MinAge;
  SELECT PersonId,DOB,FullName,GroupName, 
    'Siste BT ' + ISNULL(CONVERT(VARCHAR,SYSBP),'?') + '/' + ISNULL(CONVERT(VARCHAR,DIABP),'?') +', bruker ' + ISNULL(CONVERT(VARCHAR,BPDRUGS),'?') + ' preparater.' as InfoText
  FROM #temp WHERE ( SYSBP > 140 ) OR ( BPDRUGS > 1 ) ORDER BY FullName;
END
GO

GRANT EXECUTE ON [NDV].[GetType2WithHypertension] TO [FastTrak]
GO