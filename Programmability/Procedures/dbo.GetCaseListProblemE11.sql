﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProblemE11]( @StudyId INT ) AS 
BEGIN
 EXECUTE dbo.GetCaseListProblem @StudyId,'E11%'
END
GO