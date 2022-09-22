SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugTemplates]( @UserId INTEGER = 0 ) AS
BEGIN
  SELECT TemplateId,FriendlyName,DoseCode,ATC,DrugName,DrugForm,Strength,StrengthUnit,StartReason 
    FROM DrugTemplate WHERE CreatedBy=user_id() or @UserId=0;
END
GO

GRANT EXECUTE ON [dbo].[GetDrugTemplates] TO [FastTrak]
GO