SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetMyStudies]( @CurrentStudyId INT ) AS 
BEGIN
  SELECT StudyId, StudyName 
  FROM dbo.Study 
  WHERE ( StudyLifecycle = 2 ) OR ( IS_MEMBER( 'Pilotuser') + IS_MEMBER('db_owner') > 0  AND StudyLifecycle = 1 )
  AND StudyId <> @CurrentStudyId;
END
GO