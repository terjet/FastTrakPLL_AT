SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabData] (@PersonId INT) AS
BEGIN
  SELECT ld.ResultId, ld.LabDate, ld.LabCodeId, lc.LabName, ld.NumResult, ld.UnitStr, 
    ld.DevResult, ld.TxtResult, ld.ArithmeticComp, ld.Comment, ld.RefInterval,
	ld.SignedBy, ld.SignedAt, p.Initials, p.Signature, p.FullName
  FROM dbo.LabData ld
  JOIN dbo.LabCode lc ON lc.LabCodeId=ld.LabCodeId
  LEFT JOIN dbo.UserList ul ON ul.UserId = ld.SignedBy
  LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
  WHERE ld.PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [dbo].[GetLabData] TO [FastTrak]
GO