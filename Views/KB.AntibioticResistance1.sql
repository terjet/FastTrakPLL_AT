﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[AntibioticResistance1] AS
SELECT AtcCode, AtcName
FROM FEST.AtcIndex
WHERE AtcCode IN ( 'J01CA08', 'J01CA11', 'J01XE01' ) OR (AtcCode LIKE 'J01C[EF]%') OR (AtcCode LIKE 'J01E%');
GO