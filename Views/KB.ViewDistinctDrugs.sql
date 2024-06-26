﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[ViewDistinctDrugs]
AS
  SELECT DISTINCT PersonId,ATC FROM DrugTreatment WHERE ( ( StopAt IS NULL) OR ( StopAt > getdate() ) )
GO

GRANT SELECT ON [KB].[ViewDistinctDrugs] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [KB].[ViewDistinctDrugs] TO [public]
GO