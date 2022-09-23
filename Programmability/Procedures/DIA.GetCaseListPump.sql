SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [DIA].[GetCaseListPump]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GenderId, 
    ISNULL( diatype.OptionText, 'Type ikke oppgitt' ) AS GroupName, 
    ISNULL( pump.OptionText, ' (Ikke oppgitt)' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( 4056, NULL ) adm ON adm.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 3196, NULL) diatype ON diatype.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 5162, NULL ) pump ON pump.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND adm.EnumVal = 2
  ORDER BY diatype.OptionText, pump.OptionText, v.FullName;
END
GO

GRANT EXECUTE ON [DIA].[GetCaseListPump] TO [FastTrak]
GO