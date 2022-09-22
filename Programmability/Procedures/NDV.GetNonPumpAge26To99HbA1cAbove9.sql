﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetNonPumpAge26To99HbA1cAbove9]( @StudyId INT ) AS 
BEGIN
  EXECUTE NDV.GetNonPumpWithHighHbA1c @StudyId,26,99,9
END
GO

GRANT EXECUTE ON [NDV].[GetNonPumpAge26To99HbA1cAbove9] TO [FastTrak]
GO