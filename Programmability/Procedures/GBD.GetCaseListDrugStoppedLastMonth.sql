SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListDrugStoppedLastMonth] ( @StudyId INT ) AS
BEGIN
    SELECT v.*, dt.StopAuthorizedByName, CONCAT( dt.DrugName, ' avsluttet av ', p.FullName, ' ', CONVERT( VARCHAR, dt.StopAt, 104 ) ) AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    JOIN dbo.DrugTreatment dt ON dt.PersonId = v.PersonId AND dt.StopAt IS NOT NULL
    JOIN dbo.UserList ul ON ul.UserId = dt.StopBy
    JOIN dbo.Person p ON p.PersonId = ul.PersonId
    WHERE ( DATEDIFF( DAY, dt.StopAt, GETDATE() ) <= 30 )
	AND ( v.StudyId = @StudyId )
	ORDER BY dt.StopAt DESC;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListDrugStoppedLastMonth] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[GetCaseListDrugStoppedLastMonth] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListDrugStoppedLastMonth] TO [Lege]
GO