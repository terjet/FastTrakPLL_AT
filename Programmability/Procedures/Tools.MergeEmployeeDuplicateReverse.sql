SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[MergeEmployeeDuplicateReverse]( @DuplicatePersonId INT, @TargetPersonId INT ) AS
BEGIN
  IF NOT EXISTS( SELECT 1 FROM dbo.Person WHERE PersonId = @TargetPersonId    AND DATALENGTH(NationalId) = 11 )
  OR     EXISTS( SELECT 1 FROM dbo.Person WHERE PersonId = @DuplicatePersonId AND DATALENGTH(NationalId) = 11 )
  BEGIN
    RAISERROR( 'Rutinen kan bare brukes til å flytte data til en person med fullt fødselsnummer.', 16, 1 ); 
    RETURN -1;
  END;
  EXEC Tools.MergeEmployeeDuplicate @TargetPersonId, @DuplicatePersonId;
END
GO

GRANT EXECUTE ON [Tools].[MergeEmployeeDuplicateReverse] TO [Administrator]
GO