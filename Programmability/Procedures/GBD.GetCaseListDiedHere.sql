SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListDiedHere]( @StudyId INT ) AS
BEGIN
  DECLARE @FormId INT
  SELECT @FormId = MAX(FormId) from dbo.MetaForm where FormName = 'LS3'
  SELECT vcldh.PersonId, DOB, FullName, StudyId, GroupName, vcldh.DeathRegisteredAt, 
    InfoText = 
      CASE 
        WHEN ft.CreatedAt IS NULL THEN 'Livets siste dager: Mangler!' 
      ELSE  
        CASE 
          WHEN ft.SignedAt IS NULL THEN 'Livets siste dager: Påbegynt...' 
          ELSE 'Livets siste dager: Signert.' 
        END
      END 
  FROM GBD.ViewCaseListDiedHere AS vcldh 
  LEFT JOIN dbo.GetLastFormTable( @FormId, NULL ) ft ON ft.PersonId = vcldh.PersonId
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListDiedHere] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListDiedHere] TO [Lege]
GO