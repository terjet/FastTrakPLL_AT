SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListTIRSorted]( @StudyId INT ) AS
BEGIN 
 SELECT v.PersonId, v.DOB, v.FullName, v.GenderId,     
    CONCAT(ISNULL(cgmtype.OptionText, '(CGM ikke oppgitt)'), CONCAT(', ', ISNULL(pump.OptionText, '(Pumpe ikke oppgitt)'))) AS InfoText,
	CONCAT('TIR: ', CASE WHEN tir.Quantity IS NOT NULL AND tir.Quantity >= 0 THEN 
			CONCAT(CONVERT(VARCHAR, CAST(tir.Quantity AS INT)), '%')
		ELSE
			'Ikke oppgitt'
		END) AS GroupName
  FROM dbo.ViewActiveCaseListStub v   
  LEFT JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) diatype ON diatype.PersonId = v.PersonId     
  LEFT JOIN dbo.GetLastEnumValuesTable( 1310, NULL ) glucmon ON glucmon.PersonId = v.PersonId     
  LEFT JOIN dbo.GetLastEnumValuesTable( 4056, NULL ) adm ON adm.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 5166, NULL ) cgmtype ON cgmtype.PersonId = v.PersonId     
  LEFT JOIN dbo.GetLastEnumValuesTable( 5162, NULL ) pump ON pump.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastQuantityTable( 3849, GETDATE() ) tir ON tir.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND (adm.EnumVal = 2 OR glucmon.EnumVal = 1)
  ORDER BY tir.Quantity DESC
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListTIRSorted] TO [FastTrak]
GO