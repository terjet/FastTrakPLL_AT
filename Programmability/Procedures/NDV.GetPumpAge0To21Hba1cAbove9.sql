﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPumpAge0To21Hba1cAbove9]( @StudyId INT ) AS 
BEGIN
  EXECUTE NDV.GetPumpWithHighHbA1c @StudyId,0,21,75;
END
GO

GRANT EXECUTE ON [NDV].[GetPumpAge0To21Hba1cAbove9] TO [FastTrak]
GO