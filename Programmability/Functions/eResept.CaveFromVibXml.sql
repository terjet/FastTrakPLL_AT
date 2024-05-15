SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   FUNCTION [eResept].[CaveFromVibXml]( @XmlDoc XML ) 
RETURNS @CaveVarsel TABLE( CaveId uniqueidentifier NOT NULL PRIMARY KEY, LibId uniqueidentifier NOT NULL ) AS
BEGIN
  INSERT INTO @CaveVarsel
  SELECT 
    cid.value( '../LibId[1]', 'uniqueidentifier' ) AS LibId,
    cid.value('CaveId[1]', 'uniqueidentifier' ) AS CaveId
  FROM  @XmlDoc.nodes( 'LesVarerIBrukSvar/Resept/CaveVarsel' ) AS xd(cid);
  RETURN;
END
GO