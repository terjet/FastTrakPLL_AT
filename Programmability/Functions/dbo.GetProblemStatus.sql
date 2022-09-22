SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetProblemStatus]( @PersonId INT, @ListId INT, @ItemCode VARCHAR(8) ) RETURNS INT
AS
 /*
   Summary: Used for decision support and reporting.  Checks for presence
            of a particular problem (
   Author : Magne Rekdal
   Returns: 0 = Never used, 1 = Active problem, 2 = Not active problem
   Version: 1.0
 */
BEGIN
  DECLARE @ProbStatus INT;
  SELECT @ProbStatus = MAX(pt.ProbActive)
    FROM dbo.ClinProblem p
    JOIN dbo.MetaNomListItem li on li.ListItem=p.ListItem AND li.ListId=@ListId
    JOIN dbo.MetaNomItem i on i.ItemId=li.ItemId
    JOIN dbo.MetaProblemType pt on pt.ProbType=p.ProbType
  WHERE p.PersonId=@PersonId AND ItemCode LIKE @ItemCode;
  IF @ProbStatus IS NULL
    SET @ProbStatus=0
  ELSE
    IF @ProbStatus IN (0,1) SET @ProbStatus = 2-@ProbStatus;
  RETURN @ProbStatus;
END
GO