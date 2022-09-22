SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetClinFormAuditTrail] ( @ClinFormId INT ) AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @FormId INT;
  DECLARE @EventNum INT;
  DECLARE @StudyId INT;
  DECLARE @PersonId INT;

  -- Establish context variables for this form

  SELECT @FormId = FormId
  FROM dbo.ClinForm
  WHERE ClinFormId = @ClinFormId;
  SELECT @StudyId = ce.StudyId, @PersonId = ce.PersonId, @EventNum = ce.EventNum
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND ClinFormId = @ClinFormId;

  -- Get current data for items that appear on this form

  SELECT mi.ItemId,
    ISNULL(NULLIF(mfi.ItemHeader, ''), mfi.ItemText) AS Caption, mi.VarName,
    cdp.TextVal AS TextValNow, cdp.Quantity AS QuantityNow, cdp.DTVal AS DTValNow, cdp.EnumVal AS EnumValNow, cdp.ObsDate AS TimeNow,
    ulognow.SessId AS SessIdNow, ctnow.TouchId AS TouchIdNow, pnow.FullName AS FullNameNow,

    ISNULL(cl.LogId, 0) AS LogId, cl.TextVal AS TextValThen, cl.Quantity AS QuantityThen, cl.DTVal AS DTValThen, cl.EnumVal AS EnumValThen, cl.ObsDate AS TimeThen,
    ulog.SessId AS SessIdThen, ct.TouchId AS TouchIdThen, p.FullName AS FullNameThen,

    cdp.LockedAt, psign.FullName AS FullNameLockedBy

  FROM dbo.ClinDataPoint cdp
  JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
  JOIN dbo.MetaFormItem mfi ON mfi.ItemId = mi.ItemId AND mfi.FormId = @FormId
  JOIN dbo.ClinTouch ctnow ON ctnow.TouchId = cdp.TouchId
  JOIN dbo.UserLog ulognow ON ulognow.SessId = ctnow.SessId
  JOIN dbo.UserList ulnow ON ulnow.UserId = ulognow.UserId
  JOIN dbo.Person pnow ON pnow.PersonId = ulnow.PersonId
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId AND ce.StudyId = @StudyId AND ce.PersonId = @PersonId AND ce.EventNum = @EventNum

  -- Get historic data for the same items

  LEFT JOIN dbo.ClinDataPointLog cl ON cl.RowId = cdp.RowId
  LEFT JOIN dbo.ClinTouch ct ON ct.TouchId = cl.TouchId
  LEFT JOIN dbo.UserLog ulog ON ulog.SessId = ct.SessId
  LEFT JOIN dbo.UserList ul ON ul.UserId = ulog.UserId
  LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
  LEFT JOIN dbo.UserList usign ON usign.UserId = cdp.LockedBy
  LEFT JOIN dbo.Person psign ON psign.PersonId = usign.PersonId

  ORDER BY mfi.OrderNumber, cl.ObsDate DESC

END
GO

GRANT EXECUTE ON [report].[GetClinFormAuditTrail] TO [FastTrak]
GO