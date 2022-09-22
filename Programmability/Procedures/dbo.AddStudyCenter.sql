SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddStudyCenter]( @CenterName varchar(40) )
AS BEGIN
  IF NOT EXISTS( SELECT CenterId FROM StudyCenter WHERE CenterName=@CenterName )
    INSERT INTO StudyCenter( CenterName ) VALUES ( @CenterName )
END
GO