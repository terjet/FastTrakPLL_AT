SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[FastTrakVersions] AS
BEGIN
  SELECT v.PersonId, v.FullName, v.GroupName, 
    actprog.TextVal AS ProgVer, 
    CONVERT( DATE, pgd.EventTime ) AS ProgUpgraded, ulp.UserName AS ProgSigned,
    CONVERT( INT, actdb.Quantity ) AS DbVer,
    CONVERT( DATE, dbd.EventTime ) AS DbUpgraded, uld.UserName AS DbSigned,
    CONVERT( DATE, mtd.EventTime ) AS MetaUpdated
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.GetLastTextValuesTable( 3774, NULL ) actprog on actprog.PersonId = v.PersonId
  JOIN dbo.GetLastQuantityTable( 3812, NULL ) actdb ON actdb.PersonId = actprog.PersonId
  JOIN dbo.GetLastFormTableByName( 'DBUPGRADE_PERFORM', NULL ) dbd ON dbd.PersonId = v.PersonId
    JOIN dbo.ClinForm cfd ON cfd.ClinFormId = dbd.ClinFormId
  JOIN dbo.GetLastFormTableByName( 'FASTTRAK_UPDATE_EXE', NULL ) pgd ON pgd.PersonId = v.PersonId
    JOIN dbo.ClinForm cfp ON cfp.ClinFormId = pgd.ClinFormId
  JOIN dbo.GetLastFormTableByName( 'FASTTRAK_UPDATE_META', NULL ) mtd ON mtd.PersonId = v.PersonId
  LEFT JOIN dbo.UserList uld ON uld.UserId = cfd.SignedBy
  LEFT JOIN dbo.UserList ulp ON ulp.UserId = cfp.SignedBy
  WHERE v.StudyId = 1
  ORDER BY DbVer DESC, ProgVer DESC, MetaUpdated DESC;
END
GO

GRANT EXECUTE ON [report].[FastTrakVersions] TO [FastTrak]
GO