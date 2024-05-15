SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   FUNCTION [eResept].[SlvVarselFromXml]( @XmlDoc XML )
RETURNS @VarselSlv 
TABLE( LibId uniqueidentifier, VarselTypeV INT, VarselTypeDN VARCHAR(32), Overskrift VARCHAR(128), Varseltekst VARCHAR(MAX) ) AS
BEGIN
  /* See: https://volven.no/produkt.asp?id=485597&catID=3&subID=8 */
  INSERT INTO @VarselSlv 
  SELECT
    slv.value( '../LibId[1]', 'uniqueidentifier' ) AS LibId,
    slv.value( 'Type[1]/@V', 'INT' ) AS VarselSlvTypeV,
    slv.value( 'Type[1]/@DN', 'VARCHAR(32)' ) AS VarselSlvTypeDN,
    slv.value( 'Overskrift[1]', 'VARCHAR(128)' ) AS VarselSlvOverskrift,
    slv.value( 'Varseltekst[1]', 'VARCHAR(MAX)' ) AS VarselSlvVarseltekst
  FROM  @XmlDoc.nodes( 'LesVarerIBrukSvar/Resept/VarselSlv' ) AS xd(slv);
  RETURN;
END
GO