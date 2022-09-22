SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[GetAccessControl] AS
BEGIN
  /* Return all privileges defined in database. Can be used instead of querying eah role/profession separately, reduces getting the privileges to one query */
	SELECT *
	FROM (SELECT fp.FunctionPointId, 'PROF' AS AccessType, fpp.ProfType AS Name, fpp.AccessStateId AS AccessState, fp.DefaultAccessState AS DefaultAccessState
		FROM AccessCtrl.FunctionPoint fp
		JOIN AccessCtrl.FunctionPointProfession fpp
			ON fp.FunctionPointId = fpp.FunctionPointId
		UNION
		SELECT fp.FunctionPointId, 'ROLE' AS AccessType, fpr.RoleName AS Name, fpr.AccessStateId AS AccessState, fp.DefaultAccessState AS DefaultAccessState
		FROM AccessCtrl.FunctionPoint fp
		JOIN AccessCtrl.FunctionPointRole fpr
			ON fp.FunctionPointId = fpr.FunctionPointId
		UNION
		SELECT fp.FunctionPointId, 'DEFAULT' AS AccessType, NULL AS Name, fp.DefaultAccessState AS AccessState, fp.DefaultAccessState AS DefaultAccessState
		FROM AccessCtrl.FunctionPoint fp) a
	ORDER BY a.FunctionPointId, a.AccessType, a.Name
END
GO

GRANT EXECUTE ON [AccessCtrl].[GetAccessControl] TO [FastTrak]
GO