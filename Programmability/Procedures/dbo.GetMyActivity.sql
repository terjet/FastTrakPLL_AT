SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMyActivity]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, 
    ISNULL(sg.GroupName, '(avsluttet)') AS GroupName, 
    CONCAT( 'Sist åpnet: ',  CONVERT(VARCHAR,agg.LastActivity,106 ),' kl. ', CONVERT(VARCHAR, agg.LastActivity, 8 )) AS InfoText
  FROM dbo.StudCase sc
  JOIN dbo.Person p ON p.PersonId = sc.PersonId
  LEFT JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId
  JOIN 
  (
    SELECT PersonId, MAX(CreatedAt) AS LastActivity
    FROM dbo.CaseLog 
    WHERE CreatedBy = USER_ID() AND CreatedAt > GETDATE()-30
    GROUP BY PersonId 
  ) agg ON agg.PersonId = sc.PersonId
  WHERE sc.StudyId = @StudyId
  ORDER BY LastActivity DESC;
END
GO