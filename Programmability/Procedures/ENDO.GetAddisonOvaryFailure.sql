SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetAddisonOvaryFailure]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, v.GenderId,
    'Addison diagnoseår ' + ISNULL(CONVERT(VARCHAR, CONVERT(INT, T6089.Quantity)), 'mangler') + ', ' +
    ISNULL(T6090.OptionText, '(subtype mangler)') + '.' AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  -- Varianter av registrering av Addison
    LEFT JOIN dbo.GetLastEnumValuesTable(6090,NULL) AS T6090 ON T6090.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable(6299,NULL) AS T6299 ON T6299.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastQuantityTable(6089,NULL) AS T6089 ON T6089.PersonId = v.PersonId
  -- Ovarialsvikt som variabel
    LEFT JOIN dbo.GetLastEnumValuesTable(6318,NULL) AS T6318 ON T6318.PersonId = v.PersonId
  -- Antistoff indekser
    LEFT JOIN dbo.GetLastQuantityTable(6073,NULL) AS T6073 ON T6073.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastQuantityTable(6044,NULL) AS T6044 ON T6044.PersonId = v.PersonId
  WHERE ( v.StudyId = @StudyId AND v.GenderId = 2 ) 
    AND ( T6090.EnumVal = 1 OR T6299.EnumVal = 1 OR T6089.Quantity > 1900) 
    AND ( T6318.EnumVal= 1 OR T6073.Quantity>=65 OR T6044.Quantity >=200 )
END
GO

GRANT EXECUTE ON [ENDO].[GetAddisonOvaryFailure] TO [FastTrak]
GO