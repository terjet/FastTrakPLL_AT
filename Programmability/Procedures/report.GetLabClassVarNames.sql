SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetLabClassVarNames] AS
BEGIN
  SELECT LabClassId, ISNULL(NLK, Report.LabClassName(LabClassId)) AS VarName FROM dbo.LabClass;
END;
GO

GRANT EXECUTE ON [report].[GetLabClassVarNames] TO [FastTrak]
GO