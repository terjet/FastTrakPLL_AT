SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   FUNCTION [eResept].[InteraksjonerFromXml]( @XmlDoc XML ) 
RETURNS @InterakjonsInformasjon TABLE( LibId uniqueidentifier, Niva INT, NivaDN VARCHAR(64), Kommentar VARCHAR(256) ) AS
BEGIN
  INSERT @InterakjonsInformasjon
  SELECT 
    ii.value( '../LibId[1]', 'uniqueidentifier' ) AS LibId,
    ii.value('InteraksjonsNiva[1]/@V', 'INT' ) AS Niva,
    ii.value('InteraksjonsNiva[1]/@DN', 'VARCHAR(64)' ) AS NivaDN,
    ii.value('Kommentar[1]', 'VARCHAR(256)' ) AS InteraksjonsKommentar
   FROM  @XmlDoc.nodes( 'LesVarerIBrukSvar/Resept/InteraksjonsInformasjon' ) AS xd(ii);
   RETURN;
END
GO