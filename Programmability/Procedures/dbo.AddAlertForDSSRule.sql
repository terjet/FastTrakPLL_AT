SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddAlertForDSSRule]( @StudyId INT, @PersonId INT,@AlertLevel INT,
 @AlertClass varchar(12),@AlertFacet varchar(16))
AS
BEGIN
  DECLARE @HeadStr varchar(64);
  DECLARE @MsgStr varchar(512);
  SET @HeadStr = dbo.GetTextItem( @AlertClass,@AlertFacet+'.Header' )
  SET @MsgStr  = dbo.GetTextItem( @AlertClass,@AlertFacet )
  EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,@AlertClass,@AlertFacet,@HeadStr,@MsgStr;
END;
GO

GRANT EXECUTE ON [dbo].[AddAlertForDSSRule] TO [FastTrak]
GO