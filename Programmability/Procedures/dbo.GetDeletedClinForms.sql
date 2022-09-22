SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDeletedClinForms]( @StudyId INT, @PersonId INT )
AS 
BEGIN
  SELECT cf.ClinFormId, mf.FormTitle, NULL, dbo.ShortTime(ce.EventTime) AS EventTimeText,
    'Slettet: ' + dbo.ShortTime( cf.DeletedAt )+ ' ' + dbo.GetSign( cf.DeletedBy ) AS DeleteText, 
    'Opprettet: ' + dbo.ShortTime(cf.CreatedAt) + ' ' + dbo.GetSign( cf.CreatedBy) AS CreateText 
    FROM dbo.ClinForm cf 
    JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId
    JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId     
  WHERE ( ce.StudyId=@StudyId ) AND ( ce.PersonId=@PersonId ) AND ( NOT cf.DeletedBy IS NULL )
  ORDER BY cf.DeletedAt DESC
END
GO