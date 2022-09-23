SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN05A]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListDrug @StudyId,'N05A%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05A] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05A] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05A] TO [Lege]
GO