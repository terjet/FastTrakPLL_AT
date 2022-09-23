SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[PromForms]( @StartAt DATE, @StopAt DATE ) AS
BEGIN
  SELECT p.PersonId, mf.FormTitle, fo.FormOrderId, fo.CreatedAt, fo.ClinFormId, ul.UserName, fo.NotificationChannel,
  CONCAT( DATEPART(YEAR, fo.CreatedAt), ' - ', DATENAME( MONTH, fo.CreatedAt ) ) AS GroupHeader
  FROM PROM.FormOrder fo
  JOIN dbo.MetaForm mf ON mf.FormId = fo.FormId
  JOIN dbo.Person p ON p.PersonId = fo.PersonId AND ISNULL(p.TestCase,0) = 0
  JOIN dbo.UserList ul ON ul.UserId = fo.CreatedBy
  WHERE fo.OrderStatus = 'Completed' AND fo.CreatedAt BETWEEN @StartAt AND @StopAt
  ORDER BY fo.CreatedAt;
END
GO

GRANT EXECUTE ON [report].[PromForms] TO [FastTrak]
GO