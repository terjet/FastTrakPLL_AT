﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetIncretinUsersWithHbA1c] ( @StudyId INT ) AS 
BEGIN
  EXECUTE NDV.GetIncretinUsersWithHighHbA1c @StudyId,0,99,1;
END
GO

GRANT EXECUTE ON [NDV].[GetIncretinUsersWithHbA1c] TO [FastTrak]
GO