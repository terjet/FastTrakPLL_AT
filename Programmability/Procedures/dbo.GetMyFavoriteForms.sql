SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMyFavoriteForms]( @StudyId INT ) AS
BEGIN
  SELECT TOP 24 mf.FormId,mf.FormTitle,NULL,convert(varchar,count(*)) + ' / mnd' as n
    FROM ClinForm cf                       
    JOIN ClinEvent ce ON ce.EventId=cf.EventId AND StudyId=@StudyId
    JOIN MetaForm mf on mf.FormId=cf.FormId AND mf.FormActive=1
    WHERE cf.CreatedBy = user_id() AND ( cf.CreatedAt > getdate() - 30 ) GROUP BY mf.FormId,mf.FormTitle 
    ORDER BY count(*) DESC,mf.FormId DESC;
END
GO

GRANT EXECUTE ON [dbo].[GetMyFavoriteForms] TO [FastTrak]
GO