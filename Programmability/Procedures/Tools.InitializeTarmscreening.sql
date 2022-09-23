SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[InitializeTarmscreening] AS
BEGIN
  SET NOCOUNT ON;

  -- Set ThreadType to 4 for all items on the Lesjoner form
      
  UPDATE dbo.MetaItem 
    SET ThreadTypeId = 4
  FROM dbo.MetaItem mi
    JOIN dbo.MetaFormItem mfi ON mfi.ItemId = mi.ItemId
  WHERE mfi.FormId = 116;
  
  -- Set FORM as ItemType for Lesjoner variable
  
  UPDATE dbo.MetaItem SET ItemType = 9 WHERE ItemId = 11866;
   
END
GO

GRANT EXECUTE ON [Tools].[InitializeTarmscreening] TO [Administrator]
GO