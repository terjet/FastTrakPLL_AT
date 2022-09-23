﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPumpAll]( @StudyId INT ) AS 
BEGIN
  EXECUTE NDV.GetPumpWithHighHbA1c @StudyId,0,99,1;
END
GO

GRANT EXECUTE ON [NDV].[GetPumpAll] TO [FastTrak]
GO