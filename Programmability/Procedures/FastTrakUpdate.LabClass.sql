SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[LabClass]( @XmlDoc XML ) AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.LabClass SET VarName = CONVERT(VARCHAR,LabClassId);

  -- Convert Xml document into a temporary table matching dbo.LabClass

  SELECT x.r.value('@LabClassId', 'int') AS LabClassId,
    x.r.value('@FriendlyName', 'varchar(64)') AS FriendlyName,
    x.r.value('@VarName', 'varchar(64)') AS VarName,
    x.r.value('@IncludeRegEx', 'varchar(max)') AS IncludeRegEx,
    x.r.value('@ExcludeRegEx', 'varchar(max)') AS ExcludeRegEx,
    x.r.value('@Loinc', 'varchar(8)') AS Loinc,
    x.r.value('@FurstId', 'int') AS FurstId,
    x.r.value('@UnitStr', 'varchar(8)') AS UnitStr,
    x.r.value('@MinValid', 'decimal(12,2)') AS MinValid,
    x.r.value('@MaxValid', 'decimal(12,2)') AS MaxValid,
    x.r.value('@IsGroup', 'bit') AS IsGroup,
    x.r.value('@TrustLevel', 'int') AS TrustLevel,
    x.r.value('@NLK', 'varchar(8)') AS NLK,
    x.r.value('@ClassifyWithUnit', 'bit') AS ClassifyWithUnit,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/LabClasses/LabClass') AS x (r);

  -- Merge temporary table into dbo.LabClass on LabClassId as key.

  MERGE INTO dbo.LabClass lc USING ( SELECT * FROM #temp ) xd ON (lc.LabClassId = xd.LabClassId)

  WHEN MATCHED 
    THEN UPDATE 
    SET lc.FriendlyName = xd.FriendlyName,
        lc.VarName = xd.VarName,
	    lc.IncludeRegEx = xd.IncludeRegEx,
	    lc.ExcludeRegEx = xd.ExcludeRegEx,
	    lc.Loinc = xd.Loinc,
	    lc.FurstId = xd.FurstId,
	    lc.UnitStr = xd.UnitStr,
	    lc.MinValid = xd.MinValid,
	    lc.MaxValid = xd.MaxValid,
	    lc.IsGroup = xd.IsGroup,
	    lc.TrustLevel = xd.TrustLevel,
	    lc.NLK = xd.NLK,
        lc.ClassifyWithUnit = xd.ClassifyWithUnit,
        lc.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN 
      INSERT (LabClassId, FriendlyName, VarName, IncludeRegEx, ExcludeRegEx, Loinc, FurstId, UnitStr, MinValid, MaxValid, IsGroup, TrustLevel, NLK, ClassifyWithUnit, LastUpdate ) 
        VALUES (xd.LabClassId, xd.FriendlyName, xd.VarName, xd.IncludeRegEx, xd.ExcludeRegEx, xd.Loinc, xd.FurstId, xd.UnitStr, xd.MinValid, xd.MaxValid, xd.IsGroup, xd.TrustLevel, xd.NLK, xd.ClassifyWithUnit, xd.LastUpdate );
END;
GO