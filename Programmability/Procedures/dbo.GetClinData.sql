SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinData]( @SessId INT, @PersonId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @UserId INT;     
  DECLARE @StudyId INT;
  SELECT @StudyId=StudyId,@UserId=UserId FROM dbo.UserLog WHERE SessId=@SessId AND ClosedAt IS NULL;
  IF ISNULL(@UserId,0) <> USER_ID() 
    RAISERROR( 'The session is already closed or not opened by you!',16,1 )
  ELSE                           
  BEGIN
    SELECT 
      co.RowId,e.EventId,e.EventNum,e.EventTime,mi.VarName,co.Quantity,co.DTVal,
      co.EnumVal,co.TextVal,co.Locked,co.ChangeCount
    FROM dbo.ClinDataPoint co
      JOIN dbo.ClinEvent e ON e.EventId=co.EventId 
      JOIN dbo.MetaItem mi ON mi.ItemId=co.ItemId
    WHERE e.PersonId=@PersonId
    ORDER BY e.EventNum,e.EventId;
  END;
END
GO

GRANT EXECUTE ON [dbo].[GetClinData] TO [FastTrak]
GO