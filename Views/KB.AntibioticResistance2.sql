SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[AntibioticResistance2] AS
SELECT AtcCode, AtcName
FROM FEST.AtcIndex
WHERE ( AtcCode LIKE 'J01%' ) OR ( AtcCode = 'A07AA09' ) OR ( AtcCode = 'P01AB01' )
EXCEPT ( SELECT AtcCode, AtcName FROM KB.AntibioticResistance1 UNION SELECT AtcCode, AtcName FROM KB.AntibioticResistance3 );
GO