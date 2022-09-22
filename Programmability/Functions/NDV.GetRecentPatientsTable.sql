SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [NDV].[GetRecentPatientsTable]( @DiaType INT, @CutoffDate DateTime, @LookBehindMonths INT ) 
RETURNS @PersonList TABLE( PersonId INT NOT NULL PRIMARY KEY ) AS
BEGIN
  INSERT INTO @PersonList
  SELECT DISTINCT ce.PersonId FROM dbo.ClinDataPoint cdp
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
  JOIN dbo.StudyGroup sg ON sg.StudyId=ce.StudyId AND sg.GroupId=ce.GroupId
  JOIN dbo.UserList ul ON ul.UserId = USER_ID() AND ul.CenterId = sg.CenterId
  WHERE cdp.ItemId = 3196 
    AND ce.EventTime > DATEADD( MONTH, -@LookBehindMonths, @CutoffDate ) AND ce.EventTime < @CutoffDate
    AND cdp.EnumVal = @DiaType
  ORDER BY ce.PersonId;
  RETURN;
END
GO