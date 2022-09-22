SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateClinDataEventId]( @FormId INT, @OldEventId INT, @NewEventId INT )
AS
BEGIN
  -- Find variable names on this form
  SELECT ItemId INTO #FormItems 
  FROM dbo.MetaFormItem WHERE FormId=@FormId;                                                                       
  -- Make non-greedy by deleting all items found in other forms
  DELETE FROM #FormItems WHERE ItemId IN (SELECT mfi.ItemId FROM dbo.MetaFormItem mfi
  WHERE mfi.FormId IN ( SELECT FormId FROM dbo.ClinForm WHERE EventId=@OldEventId AND FormId <> @FormId) AND ISNULL(mfi.ReadOnly,0) = 0 );
  -- Move all standard variables
  UPDATE dbo.ClinDatapoint SET EventId = @NewEventId WHERE EventId = @OldEventId
  AND ItemId IN ( SELECT ItemId FROM #FormItems ); 
  -- Move all threaded variables
  UPDATE dbo.ClinThreadData SET EventId = @NewEventId WHERE EventId = @OldEventId
  AND ItemId IN ( SELECT ItemId FROM #FormItems ); 
END
GO

GRANT EXECUTE ON [dbo].[UpdateClinDataEventId] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateClinDataEventId] TO [ReadOnly]
GO