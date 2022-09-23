SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNoECG6Months]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListLastForm @StudyId,'GBD_EKG',180
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoECG6Months] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoECG6Months] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoECG6Months] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoECG6Months] TO [Vernepleier]
GO