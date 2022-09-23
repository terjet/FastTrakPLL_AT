SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListUnsignedFormsByPerson]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, 
    mf.FormTitle + ', ' + dbo.LongTime( ce.EventTime) as InfoText,
    ulf.UserId as FormUserId,me.UserId as MyUserId
  FROM ViewActiveCaseListStub v
    JOIN dbo.ClinEvent ce ON ce.PersonId=v.PersonId
    JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId AND cf.SignedAt IS NULL and cf.DeletedAt IS NULL
    JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId    
    JOIN dbo.UserList ulf ON ulf.UserId=cf.CreatedBy
    JOIN dbo.UserList me ON me.UserId=USER_ID() AND me.PersonId=ulf.PersonId 
    WHERE v.StudyId=@StudyId
  ORDER BY ce.EventTime
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListUnsignedFormsByPerson] TO [FastTrak]
GO