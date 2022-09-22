SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[DbProcList]( @XmlDoc XML ) AS
BEGIN
  SET NOCOUNT ON;

  -- Convert Xml document into a temporary table matching dbo.DbProcList

  SELECT x.r.value('@ProcId', 'int') AS ProcId,
    x.r.value('@ListId', 'varchar(8)') AS ListId,
    x.r.value('@ProcName', 'varchar(64)') AS ProcName,
    x.r.value('@ProcDesc', 'varchar(64)') AS ProcDesc,
    x.r.value('@ProcParams', 'varchar(64)') AS ProcParams,
    x.r.value('@StudyName', 'varchar(40)') AS StudyName,
    x.r.value('@ProcSourceCode', 'varchar(max)') AS ProcSourceCode,
    x.r.value('@HelpText', 'varchar(max)') AS HelpText,
    x.r.value('@InfoCaption', 'varchar(64)') AS InfoCaption,
    x.r.value('@MinVersion', 'int') AS MinVersion,
    x.r.value('@MaxVersion', 'int') AS MaxVersion,
    x.r.value('@GrantTo', 'varchar(max)') AS GrantTo,
    x.r.value('@DenyTo', 'varchar(max)') AS DenyTo,
    x.r.value('@ChkSum', 'int') AS ChkSum,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/DbProcList/row') AS x (r);

  -- Merge temporary table into dbo.LabClass on LabClassId as key.

  MERGE INTO dbo.DbProcList trg USING ( SELECT * FROM #temp ) xd ON (trg.ProcId = xd.ProcId)

  WHEN MATCHED 
    THEN UPDATE 
    SET 
      trg.ListId = xd.ListId,
      trg.ProcName = xd.ProcName,
      trg.ProcDesc = xd.ProcDesc,
      trg.ProcParams = xd.ProcParams,
      trg.StudyName = xd.StudyName,
      trg.ProcSourceCode = xd.ProcSourceCode,
      trg.HelpText = xd.HelpText,
      trg.InfoCaption = xd.InfoCaption,
      trg.MinVersion = xd.MinVersion,
      trg.MaxVersion = xd.MaxVersion,
      trg.GrantTo = xd.GrantTo,
      trg.DenyTo = xd.DenyTo,
      trg.ChkSum = xd.chkSum,
      trg.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN 
      INSERT ( ProcId, ListId, ProcName, ProcDesc, ProcParams, StudyName, ProcSourceCode, HelpText, InfoCaption, 
        MinVersion, MaxVersion, GrantTo, DenyTo, ChkSum, LastUpdate ) 
      VALUES ( xd.ProcId, xd.ListId, xd.ProcName, xd.ProcDesc, xd.ProcParams, xd.StudyName, xd.ProcSourceCode, xd.HelpText, xd.InfoCaption, 
        xd.MinVersion, xd.MaxVersion, xd.GrantTo, xd.DenyTo, xd.ChkSum, xd.LastUpdate );
END;
GO