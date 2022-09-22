SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[PIA]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;
  SET LANGUAGE Norwegian;

  UPDATE FEST.PIA SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching FEST.PIA

  SELECT x.r.value('@PackId', 'int') AS PackId,
    x.r.value('@ATC', 'varchar(7)') AS ATC,
    x.r.value('@DrugName', 'varchar(128)') AS DrugName,
    x.r.value('@DrugForm', 'varchar(64)') AS DrugForm,
    x.r.value('@DrugGroup', 'varchar(1)') AS DrugGroup,
    x.r.value('@Strength', 'decimal(18,4)') AS Strength,
    x.r.value('@StrengthUnit', 'varchar(24)') AS StrengthUnit,
    x.r.value('@SubstanceName', 'varchar(128)') AS SubstanceName,
    x.r.value('@PackSize', 'decimal(18,4)') AS PackSize,
    x.r.value('@PackSizeUnit', 'varchar(10)') AS PackSizeUnit,
    x.r.value('@PackQuantity', 'varchar(3)') AS PackQuantity,
    x.r.value('@PackName', 'varchar(64)') AS PackName,
    x.r.value('@PackInfo', 'varchar(40)') AS PackInfo,
    x.r.value('@Refundable', 'varchar(1)') AS Refundable,
    x.r.value('@DrugNameFormStrength', 'varchar(128)') AS DrugNameFormStrength,
    x.r.value('@DoseUnit', 'varchar(24)') AS DoseUnit, 
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate 
	INTO #temp
  FROM @XmlDoc.nodes('/PIA/drug') AS x (r);
  
  -- Merge temporary table into FEST.PIA on PackId as key.

  MERGE INTO FEST.PIA fpi USING (SELECT * FROM #temp ) xd ON (fpi.PackId = CONVERT(INT,xd.PackId))

  WHEN MATCHED
    THEN UPDATE 
    SET fpi.ATC = xd.ATC,
        fpi.DrugName = xd.DrugName,
        fpi.DrugForm = xd.DrugForm,
        fpi.DrugGroup = xd.DrugGroup,
        fpi.Strength = xd.Strength,
        fpi.StrengthUnit = xd.StrengthUnit,
        fpi.SubstanceName = xd.SubstanceName,
        fpi.PackSize = xd.PackSize,
        fpi.PackSizeUnit = xd.PackSizeUnit,
        fpi.PackQuantity = xd.PackQuantity,
        fpi.PackName = xd.PackName,
        fpi.PackInfo = xd.PackInfo,
        fpi.Refundable = xd.Refundable,
        fpi.DrugNameFormStrength = xd.DrugNameFormStrength,
        fpi.DoseUnit = xd.DoseUnit,
        fpi.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN
      INSERT (PackId, ATC, DrugName, DrugForm, DrugGroup, Strength, StrengthUnit,
	    SubstanceName, PackSize, PackSizeUnit, PackQuantity, PackName, PackInfo,
		Refundable, DrugNameFormStrength, DoseUnit, LastUpdate ) 
        VALUES (xd.PackId, xd.ATC, xd.DrugName, xd.DrugForm, xd.DrugGroup, xd.Strength, xd.StrengthUnit,
	    xd.SubstanceName, xd.PackSize, xd.PackSizeUnit, xd.PackQuantity, xd.PackName, xd.PackInfo,
		xd.Refundable, xd.DrugNameFormStrength, xd.DoseUnit, xd.LastUpdate );

  DELETE FROM FEST.PIA WHERE LastUpdate = '1980-01-01';

END;
GO