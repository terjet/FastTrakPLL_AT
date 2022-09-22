SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[EnableDelete]( @StudName sysname )
AS
BEGIN
  DECLARE @StudyId INT;                                        
  DECLARE @DelName VARCHAR(40);
  SELECT @StudyId = StudyId FROM Study WHERE StudName=@StudName
  IF NOT @StudyId IS NULL BEGIN
    SET IDENTITY_INSERT Study ON
    SET @DelName = @StudName + ' slettinger';
    INSERT INTO Study (StudyId,StudName) VALUES( -@StudyId, @DelName)
    SET IDENTITY_INSERT Study OFF
  END;
END;
GO