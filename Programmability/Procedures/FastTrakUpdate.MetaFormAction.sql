SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaFormAction]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  UPDATE dbo.MetaFormAction SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching dbo.MetaForm

  SELECT x.r.value('@OrderNumber', 'int') AS OrderNumber,
    x.r.value('@PageConditionId', 'int') AS PageConditionId,
    x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@MasterId', 'int') AS MasterId,
    x.r.value('@DetailId', 'int') AS DetailId,
    x.r.value('@MasterEnumVal', 'int') AS MasterEnumVal,
    x.r.value('@ComparisonType', 'int') AS ComparisonType,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaFormAction/Row') AS x (r);

  -- Merge temporary table into dbo.MetaForm on FormId as key.

  MERGE INTO dbo.MetaFormAction mfa USING ( SELECT * FROM #temp ) xd ON ( mfa.OrderNumber = xd.OrderNumber )

  WHEN MATCHED 
    THEN UPDATE 
    SET mfa.PageConditionId = xd.PageConditionId,
	    mfa.FormId = xd.FormId,
        mfa.MasterId = xd.MasterId,
        mfa.DetailId = xd.DetailId,
        mfa.MasterEnumVal= xd.MasterEnumVal,
        mfa.ComparisonType = xd.ComparisonType,
        mfa.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN 
      INSERT ( OrderNumber, PageConditionId, FormId, MasterId, DetailId, MasterEnumVal, ComparisonType, LastUpdate) 
        VALUES (xd.OrderNumber, xd.PageConditionId, xd.FormId, xd.MasterId, xd.DetailId, xd.MasterEnumVal, xd.ComparisonType, xd.LastUpdate);

 DELETE FROM  dbo.MetaFormAction WHERE LastUpdate = '1980-01-01';

END;
GO