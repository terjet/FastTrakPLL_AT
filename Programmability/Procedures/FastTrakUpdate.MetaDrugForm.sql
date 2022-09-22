SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaDrugForm]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- Convert Xml document into a temporary table matching dbo.MetaDrugForm

  SELECT x.r.value('@DrugFormId', 'int') AS DrugFormId,
    x.r.value('@StudyName', 'varchar(32)' ) AS StudyName,
    x.r.value('@FormName', 'varchar(32)') AS FormName,
    x.r.value('@AtcPattern', 'varchar(32)') AS AtcPattern,
    x.r.value('@InfoHeader', 'varchar(32)') AS InfoHeader,
    x.r.value('@InfoMessage', 'varchar(max)') AS InfoMessage,
    x.r.value('@ReplacesDrugDosing', 'bit') AS ReplacesDrugDosing,
    x.r.value('@AddByDefault', 'bit') AS AddByDefault
  INTO #temp
  FROM @XmlDoc.nodes('/MetaDrugForms/MetaDrugForm') AS x (r);

  -- Merge temporary table into dbo.MetaDrugForm on DrugFormId as key.

  MERGE INTO dbo.MetaDrugForm mdf USING (SELECT t.*,s.StudyId FROM #temp t JOIN dbo.Study s ON s.StudyName = t.StudyName ) xd ON (mdf.DrugFormId = xd.DrugFormId)

  WHEN MATCHED
    THEN UPDATE 
    SET mdf.StudyId = xd.StudyId,
        mdf.FormName = xd.FormName,
        mdf.AtcPattern = xd.AtcPattern,
        mdf.InfoHeader = xd.InfoHeader,
        mdf.InfoMessage = xd.InfoMessage,
        mdf.ReplacesDrugDosing = xd.ReplacesDrugDosing,
        mdf.AddByDefault = xd.AddByDefault
  WHEN NOT MATCHED
    THEN 
      INSERT (DrugFormId, StudyId, FormName, AtcPattern, InfoHeader, InfoMessage, ReplacesDrugDosing, AddByDefault ) 
        VALUES (xd.DrugFormId, xd.StudyId, xd.FormName, xd.AtcPattern, xd.InfoHeader, xd.InfoMessage, xd.ReplacesDrugDosing, xd.AddByDefault );
END;
GO