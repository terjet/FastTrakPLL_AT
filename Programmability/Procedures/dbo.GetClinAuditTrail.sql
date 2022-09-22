SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinAuditTrail]( @RowId INT ) AS
BEGIN
  SELECT 
    cl.ObsDate, cl.Quantity, cl.DTVal, cl.EnumVal, cl.TextVal,
    p.Signature, ul.CompUser, ul.CompName, ul.UserName AS DbUser
  FROM dbo.ClinDataPointLog cl
  JOIN dbo.ClinTouch ct ON ct.TouchId=cl.TouchId
  JOIN dbo.UserLog ul ON ul.SessId=ct.SessId
  JOIN dbo.UserList usr ON usr.UserId=ct.CreatedBy
  JOIN dbo.Person p ON p.PersonId=usr.PersonId
  WHERE cl.RowId=@RowId;
END
GO

GRANT EXECUTE ON [dbo].[GetClinAuditTrail] TO [FastTrak]
GO