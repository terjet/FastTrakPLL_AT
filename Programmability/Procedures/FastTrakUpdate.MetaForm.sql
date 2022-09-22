SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaForm]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- Convert Xml document into a temporary table matching dbo.MetaForm

  SELECT x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@FormName', 'varchar(24)') AS FormName,
    x.r.value('@FormTitle', 'varchar(128)') AS FormTitle,
    x.r.value('@SurveyStatus', 'varchar(6)') AS SurveyStatus,
    x.r.value('@CalculateInvalid', 'bit') AS CalculateInvalid,
    x.r.value('@RatingScale', 'bit') AS RatingScale,
    x.r.value('@Copyright', 'varchar(max)') AS Copyright,
    x.r.value('@Instructions', 'varchar(max)') AS Instructions,
    x.r.value('@Repeatable', 'bit') AS Repeatable,
    x.r.value('@ThreadTypeId', 'int') AS ThreadTypeId,
    x.r.value('@ParentId', 'int') AS ParentId,
    x.r.value('@Subtitle', 'varchar(max)') AS Subtitle,
    x.r.value('@FormDateItemId', 'int') AS FormDateItemId,
    x.r.value('@AfterSaveProcId', 'int') AS AfterSaveProcId,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaForm/Row') AS x (r);

  -- Merge temporary table into dbo.MetaForm on FormId as key.

  MERGE INTO dbo.MetaForm mf USING (SELECT * FROM #temp ) xd ON (mf.FormId = xd.FormId)

  WHEN MATCHED
    THEN UPDATE 
    SET mf.FormName = xd.FormName,
        mf.FormTitle = xd.FormTitle,
        mf.SurveyStatus = xd.SurveyStatus,
        mf.CalculateInvalid = xd.CalculateInvalid,
        mf.RatingScale = xd.RatingScale,
        mf.Copyright = xd.Copyright,
        mf.Instructions = xd.Instructions,
        mf.Repeatable = xd.Repeatable,
        mf.ThreadTypeId = xd.ThreadTypeId,
        mf.ParentId = xd.ParentId,
        mf.Subtitle = xd.Subtitle,
        mf.FormDateItemId = xd.FormDateItemId,
        mf.AfterSaveProcId = xd.AfterSaveProcId,
        mf.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN 
      INSERT (FormId, FormName, FormTitle, SurveyStatus, CalculateInvalid, RatingScale, Instructions, Copyright,
        Repeatable, ThreadTypeId, ParentId, Subtitle, FormDateItemId, AfterSaveProcId, LastUpdate ) 
      VALUES (xd.FormId, xd.FormName, xd.FormTitle, xd.SurveyStatus, xd.CalculateInvalid, xd.RatingScale, xd.Instructions, xd.Copyright,
        xd.Repeatable, xd.ThreadTypeId, xd.ParentId, xd.Subtitle, xd.FormDateItemId, xd.AfterSaveProcId, xd.LastUpdate );
END;
GO