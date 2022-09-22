SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetTextSiblings](
 @MatchStr NVARCHAR(24), @VarName1 VARCHAR(24), @VarName2 VARCHAR(24),
 @VarName3 VARCHAR(24) = NULL, @VarName4 VARCHAR(24) = NULL, @VarName5 VARCHAR(24) = NULL
)
AS
  DECLARE @SqlText NVARCHAR(1024);
  DECLARE @SqlJoin NVARCHAR(512);
  DECLARE @ParDef NVARCHAR(256);
BEGIN
  /* Set up the first two fields */
  SET @ParDef = N'@MatchStr NVARCHAR(24),@VarName1 VARCHAR(24),@VarName2 VARCHAR(24)';
  SET @SqlText =
     'SELECT DISTINCT DATEPART(yy,c1.ObsDate) AS YearUsed,c1.TextVal AS ' + @VarName1 +
     ',c2.TextVal AS ' + @VarName2;
  SET @SqlJoin = ' FROM clinObservation c1 JOIN clinObservation c2 ON c2.EventId=c1.EventId AND c2.VarName=@VarName2';
  /* Add optional 3 and 4 */
  IF NOT @VarName3 IS NULL BEGIN
    SET @SqlText = @SqlText + ',c3.TextVal AS ' + @VarName3;
    SET @SqlJoin = @SqlJoin + ' JOIN clinObservation c3 ON c3.EventId=c1.EventId AND c3.VarName=@VarName3';
    SET @ParDef = @ParDef + N',@VarName3 varchar(24)';
    IF NOT @VarName4 IS NULL BEGIN
      SET @SqlText = @SqlText + ',c4.TextVal AS ' + @VarName4;
      SET @SqlJoin = @SqlJoin + ' JOIN clinObservation c4 ON c4.EventId=c1.EventId AND c4.VarName=@VarName4';
      SET @ParDef = @ParDef + N',@VarName4 varchar(24)';
      IF NOT @VarName5 IS NULL BEGIN
        SET @SqlText = @SqlText + ',c5.TextVal AS ' + @VarName4;
        SET @SqlJoin = @SqlJoin + ' JOIN clinObservation c5 ON c5.EventId=c1.EventId AND c5.VarName=@VarName5';
        SET @ParDef = @ParDef + N',@VarName5 varchar(24)';
      END;
    END;
  END;
  SET @SqlText = @SqlText + @SqlJoin +
  ' WHERE c1.VarName=@VarName1 '+
  ' AND c1.TextVal LIKE @MatchStr ' +
  ' ORDER BY DATEPART(yy,c1.ObsDate),c1.TextVal';
  PRINT @SqlText;
  IF @VarName3 IS NULL
    EXEC sp_executesql @SqlText,@ParDef,@MatchStr,@VarName1,@VarName2
  ELSE IF @VarName4 IS NULL
    EXEC sp_executesql @SqlText,@ParDef,@MatchStr,@VarName1,@VarName2,@VarName3
  ELSE IF @VarName5 IS NULL
    EXEC sp_executesql @SqlText,@ParDef,@MatchStr,@VarName1,@VarName2,@VarName3,@VarName4;
  ELSE
    EXEC sp_executesql @SqlText,@ParDef,@MatchStr,@VarName1,@VarName2,@VarName3,@VarName5;
END
GO