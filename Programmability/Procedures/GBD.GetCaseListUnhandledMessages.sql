SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListUnhandledMessages]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.StudyId,v.GroupName,v.GenderId, 'Meldinger ' + CONVERT(VARCHAR,w.NewMsgCount) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN Comm.NewMessageWarning w ON w.PersonId=v.PersonId
  WHERE w.NewMsgCount > 0
  ORDER BY NewMsgCount DESC
END
GO