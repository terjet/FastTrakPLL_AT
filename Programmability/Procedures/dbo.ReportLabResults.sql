SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportLabResults]( @PersonId INT ) AS
BEGIN
  SELECT ld.ResultId, ld.LabDate, ld.LabCodeId, lc.LabName, ld.NumResult, ld.UnitStr, 
    mdr.OID9533, ld.TxtResult, CompSign =
    CASE ld.ArithmeticComp
      WHEN 'GT' THEN '<'
      WHEN 'LT' THEN '>' 
      ELSE ld.ArithmeticComp
    END,       
    ld.Comment, 
    ld.RefInterval,
    (per.Signature + ' ' + FORMAT(ld.signedAt,'dd.MM.yyyy')) AS Signature
  FROM dbo.LabData ld
  JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
  LEFT JOIN dbo.MetaDevResult mdr ON mdr.DevResult=ld.DevResult
  LEFT JOIN dbo.UserList ul ON ul.UserId = ld.SignedBy
  LEFT JOIN dbo.Person per ON per.PersonId = ul.PersonId
  WHERE ld.PersonId = @PersonId
  ORDER BY ld.LabDate DESC, lc.LabName;
END
GO

GRANT EXECUTE ON [dbo].[ReportLabResults] TO [FastTrak]
GO