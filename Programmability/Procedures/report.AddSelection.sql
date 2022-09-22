SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[AddSelection]( @StudyId INT, @SelTitle VARCHAR(80), @SelDescription VARCHAR(MAX) ) 
AS
BEGIN
  INSERT INTO Report.Selection( StudyId, SelTitle, SelDescription ) VALUES( @StudyId, @SelTitle, @SelDescription );
  SELECT SCOPE_IDENTITY() AS SelId;
END
GO

GRANT EXECUTE ON [report].[AddSelection] TO [FastTrak]
GO