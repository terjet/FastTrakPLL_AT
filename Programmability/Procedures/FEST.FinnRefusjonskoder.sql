SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FEST].[FinnRefusjonskoder]( @ATC VARCHAR(7) ) AS 
BEGIN
  DECLARE @OID INT;
  DECLARE @AltOID INT;      
  -- Choose alternative OID based on ICPC/ICD10 problem list
  SELECT @OID = OID FROM dbo.MetaNomList l JOIN dbo.UserList ul ON ul.ProbListId = l.ListId AND ul.UserId=USER_ID();
  IF @OID = 7110 SET @AltOid=7435;
  IF @OID = 7170 SET @AltOId=7434;
  -- Find matching codes for ATC
  SELECT rk.V as CodeText, ISNULL(rk.Underterm,rk.DN) as CodeHeader,rk.OID,rg.GruppeNavn,rg.RefRefusjonshjemmel AS OID7427
    INTO #temp
    FROM FEST.Refusjonskode rk 
    JOIN FEST.Refusjonsgruppe rg ON rg.Id = rk.RefRefusjonsgruppe
  WHERE CHARINDEX(rg.ATC,@ATC)=1 
    AND ( rg.Status='A' )
    AND ( ( rk.OID = @OID ) OR ( rk.OID = @AltOid ) )
    AND ( ( rk.GyldigFraDato < getdate() ) AND ( ISNULL(rk.GyldigTilDato,getdate()+1) > getdate() ) ); 
  -- Select codes without duplicates 
  SELECT DISTINCT mr.CodeId,t.CodeText,t.CodeHeader,mr.CodeText as CodeInfo 
    FROM #temp t JOIN dbo.MetaReimbursementCode mr ON mr.OID7427=t.OID7427
    ORDER BY t.CodeText,mr.CodeText 
END
GO