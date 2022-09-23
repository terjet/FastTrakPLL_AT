SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleLabData]( @StudyId INT, @PersonId INT ) AS
BEGIN
  IF EXISTS( SELECT ResultId FROM dbo.LabData WHERE PersonId=@PersonId
    AND LabDate > getdate()-180 )
    EXEC dbo.AddAlertForPerson @StudyId,@PersonId,1,'LAB','DataFound','Labdata funnet',
      'Eksterne labdata er funnet siste 6 mnd'
  ELSE
    EXEC dbo.AddAlertForPerson @StudyId,@PersonId,2,'LAB','DataMissing','Labdata mangler',
      'Ingen eksterne labdata fra siste 6 mnd.  Labprøver bør tas regelmessig, bl.a. for å overvåke nyrefunksjon.';
END
GO

GRANT EXECUTE ON [GBD].[RuleLabData] TO [FastTrak]
GO