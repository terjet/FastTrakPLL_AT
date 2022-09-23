SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetType1WithHbA1c]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId,p.DOB,p.FullName,p.GroupName,
    COALESCE(ld.LabName + ' = ' + CONVERT(VARCHAR,ld.NumResult ) +' (' +
    CONVERT(VARCHAR,DATEPART(YYYY,ld.LabDate)) + ')','(ikke målt)') AS InfoText
  FROM NDV.Type1 p
  LEFT JOIN dbo.GetLastLabDataTable( 1058, '3000-01-01' ) ld ON ld.PersonId= p.PersonId
  ORDER BY ISNULL(ld.NumResult,999) DESC
END
GO

GRANT EXECUTE ON [NDV].[GetType1WithHbA1c] TO [FastTrak]
GO