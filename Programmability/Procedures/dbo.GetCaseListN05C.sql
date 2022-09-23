SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN05C]( @StudyId INT ) AS
BEGIN 
  EXEC dbo.GetCaseListDrug @StudyId,'N05C%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05C] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05C] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05C] TO [Lege]
GO