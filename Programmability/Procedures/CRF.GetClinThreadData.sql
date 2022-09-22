SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetClinThreadData]( @StudyId INT, @PersonId INT )
AS
BEGIN
   SELECT 
    ctd.RowId, ctd.ThreadId, ct.ThreadName, ctf.ClinFormId, ce.EventId, ce.EventNum, ce.EventTime, mi.ItemId, mi.VarName, 
    ctd.Quantity, ctd.EnumVal, ctd.DTVal, ctd.TextVal, 
    ctd.ObsDate, ctd.Locked, ctd.ChangeCount, ctd.TouchId
  FROM dbo.ClinThreadData ctd
    JOIN dbo.ClinThread ct ON ct.ThreadId = ctd.ThreadId
    JOIN CRF.ClinThreadForm ctf ON ctf.ThreadId = ct.ThreadId
    JOIN dbo.ClinEvent ce ON ce.EventId = ctd.EventId 
    JOIN dbo.MetaItem mi ON mi.ItemId = ctd.ItemId
  WHERE ce.PersonId = @PersonId
  ORDER BY ce.EventNum,ce.EventId;
END
GO

GRANT EXECUTE ON [CRF].[GetClinThreadData] TO [FastTrak]
GO