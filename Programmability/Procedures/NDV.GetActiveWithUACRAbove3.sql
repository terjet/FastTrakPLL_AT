﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetActiveWithUACRAbove3]( @StudyId INT ) AS
BEGIN 
  EXECUTE NDV.GetActiveWithHighUACR @StudyId,3.01
END
GO

GRANT EXECUTE ON [NDV].[GetActiveWithUACRAbove3] TO [FastTrak]
GO