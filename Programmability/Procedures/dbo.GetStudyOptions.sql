﻿SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyOptions]( @StudName VARCHAR(40) )
AS
BEGIN
  SELECT * FROM Study WHERE StudName LIKE @StudName;
END
GO

GRANT EXECUTE ON [dbo].[GetStudyOptions] TO [FastTrak]
GO