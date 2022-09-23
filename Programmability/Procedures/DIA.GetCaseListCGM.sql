SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [DIA].[GetCaseListCGM]( @StudyId INT ) AS 
BEGIN   
  SELECT v.PersonId, v.DOB, v.FullName, v.GenderId,     
    diatype.OptionText AS GroupName, 
    ISNULL(cgmtype.OptionText, '(CGM ikke oppgitt)') AS InfoText   
  FROM dbo.ViewActiveCaseListStub v   
  JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) diatype ON diatype.PersonId = v.PersonId     
  JOIN dbo.GetLastEnumValuesTable( 1310, NULL ) glucmon ON glucmon.PersonId = v.PersonId     
  LEFT JOIN dbo.GetLastEnumValuesTable( 5166, NULL ) cgmtype ON cgmtype.PersonId = v.PersonId     
  WHERE v.StudyId = @StudyId AND glucmon.EnumVal = 1
  ORDER BY cgmtype.OptionText, v.FullName;
END
GO

GRANT EXECUTE ON [DIA].[GetCaseListCGM] TO [FastTrak]
GO