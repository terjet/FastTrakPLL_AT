SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetReplaceConflictCount]( @FormId INT, @OldItemId INT, @NewItemId INT ) RETURNS INT
AS
BEGIN
  DECLARE @RetVal INT;
  SELECT @RetVal =  count(a.ProbCount) 
  FROM
    ( 
    SELECT EventId,count(*) AS ProbCount from ClinDataPoint 
    WHERE ItemId in (@OldItemId,@NewItemId)
	AND EventId IN ( SELECT EventId FROM dbo.ClinForm WHERE FormId=@FormId )
    GROUP BY EventId
    HAVING count(*) > 1 
    )  a;
  RETURN @RetVal;
END
GO