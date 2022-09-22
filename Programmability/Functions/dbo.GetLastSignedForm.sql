SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastSignedForm]( @StudyId INT, @PersonId INT, @FormName VarChar(24) ) RETURNS DateTime
AS
BEGIN
  DECLARE @LastFormDate DateTime;
  SELECT @LastFormDate = MAX(EventTime) FROM ClinEvent e
  JOIN ClinForm f ON f.EventId=e.EventId AND e.StudyId=@StudyId AND e.PersonId=@PersonId
  JOIN MetaForm m ON m.FormId=f.FormId AND m.FormName = @FormName and f.FormStatus='L';
  RETURN @LastFormDate;
END
GO

GRANT EXECUTE ON [dbo].[GetLastSignedForm] TO [FastTrak]
GO