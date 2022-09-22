SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyStatus]( @StudyId INT )
AS
BEGIN
  SELECT StatusId,StatusText FROM StudyStatus WHERE ( StudyId=@StudyId ) AND ( DisabledAt IS NULL ) ORDER BY StatusId
END
GO