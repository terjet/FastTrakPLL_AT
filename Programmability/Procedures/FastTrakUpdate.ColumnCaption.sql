SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[ColumnCaption]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- Convert Xml document into a temporary table matching Report.ColumnCaption

  SELECT x.r.value('@CaptionId', 'int') AS CaptionId,
    x.r.value('@VarSpec', 'varchar(64)') AS VarSpec,
    x.r.value('@Caption', 'varchar(8)') AS Caption,
    x.r.value('@ColWidth', 'int') AS ColWidth,
    x.r.value('@ChkSum', 'int') AS ChkSum INTO #temp
  FROM @XmlDoc.nodes('/ColumnCaption/Row') AS x (r);

  -- Merge temporary table into Report.ColumnCaption on CaptionId as key.

  MERGE INTO Report.ColumnCaption rcc USING ( SELECT * FROM #temp ) xd ON (rcc.CaptionId = xd.CaptionId)

  WHEN MATCHED AND rcc.ChkSum <> xd.ChkSum
    THEN UPDATE 
    SET rcc.VarSpec = xd.VarSpec,
	    rcc.Caption = xd.Caption,
        rcc.ColWidth = xd.ColWidth,
        rcc.ChkSum = xd.chkSum
  WHEN NOT MATCHED
    THEN 
      INSERT (CaptionId, VarSpec, Caption, ColWidth, ChkSum) 
        VALUES (xd.CaptionId, xd.VarSpec, xd.Caption, xd.ColWidth, xd.ChkSum );
END;
GO