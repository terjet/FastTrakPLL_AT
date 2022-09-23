SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListN05B]( @StudyId INT ) AS
BEGIN 
  EXEC dbo.GetCaseListDrug @StudyId,'N05B%'
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05B] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05B] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListN05B] TO [Lege]
GO