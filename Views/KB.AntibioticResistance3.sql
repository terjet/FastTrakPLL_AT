﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[AntibioticResistance3] AS
SELECT AtcCode, AtcName 
FROM FEST.AtcIndex
WHERE ( AtcCode LIKE 'J01CR%' ) OR ( AtcCode LIKE 'J01D[ABCDEHI]%' ) OR ( AtcCode LIKE 'J01M%' );
GO