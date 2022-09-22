SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteClinProblem]( @ProbId INT ) AS 
  DECLARE @PersonId INT;
  DECLARE @MsgText varchar(512);
BEGIN
  /* Find person and at the same time determine deletability of problem */
  SELECT @PersonId = PersonId FROM ClinProblem WHERE ProbId=@ProbId 
    AND CreatedBy=USER_ID() AND ( CreatedAt>getdate()-1 ); 
  IF @PersonId IS NULL BEGIN
    SET @MsgText = dbo.GetTextItem( 'DeleteClinProblem','Failed')
    RAISERROR( @MsgText, 16, 1 ); 
    RETURN -1   
  END
  ELSE BEGIN
    DELETE FROM ClinProblem WHERE ProbId=@ProbId;
    UPDATE StudCase SET LastWrite = getdate() WHERE PersonId=@PersonId;
    RETURN 0;
  END;
END
GO