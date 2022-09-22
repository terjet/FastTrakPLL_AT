SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMetaProblemTypes] AS
SELECT ProbType,ProbDesc,ProbActive FROM MetaProblemType
GO

GRANT EXECUTE ON [dbo].[GetMetaProblemTypes] TO [FastTrak]
GO