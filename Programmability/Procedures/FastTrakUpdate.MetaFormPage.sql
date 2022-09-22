SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaFormPage]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;
  
  UPDATE dbo.MetaFormPage SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching dbo.MetaFormPage

  SELECT x.r.value('@PageId', 'int') AS PageId,
    x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@PageNumber', 'int') AS PageNumber,
    x.r.value('@PageTitle', 'varchar(max)') AS PageTitle,
    x.r.value('@PageIntroduction', 'varchar(max)') AS PageIntroduction,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaFormPage/Row') AS x (r);

  -- Merge temporary table into dbo.MetaFormPage on PageId as key.

  MERGE INTO dbo.MetaFormPage mfp USING (SELECT * FROM #temp ) xd ON (mfp.PageId = xd.PageId)

  WHEN MATCHED
    THEN UPDATE 
    SET mfp.FormId = xd.FormId,
        mfp.PageNumber = xd.PageNumber,
        mfp.PageTitle = xd.PageTitle,
        mfp.PageIntroduction = xd.PageIntroduction,
        mfp.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN INSERT (PageId, FormId, PageNumber, PageTitle, PageIntroduction, LastUpdate )
      VALUES (xd.PageId, xd.FormId, xd.PageNumber, xd.PageTitle, xd.PageIntroduction, xd.LastUpdate);

 DELETE FROM  dbo.MetaFormPage WHERE LastUpdate = '1980-01-01';

END;
GO