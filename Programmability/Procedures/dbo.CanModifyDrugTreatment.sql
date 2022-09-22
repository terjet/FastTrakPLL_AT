SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CanModifyDrugTreatment] ( @UserId INTEGER = NULL, @CanModify BIT OUTPUT, @ErrMsg VARCHAR(512) OUTPUT) 
AS
BEGIN
  SET @UserId = ISNULL(@UserId,USER_ID());
  SET @ErrMsg = '';
  SET @CanModify = 0;

  SELECT @CanModify = 1
    FROM dbo.UserList ul JOIN dbo.MetaProfession mp ON mp.ProfId=ul.ProfId
   WHERE ul.UserId=@UserId
   AND mp.ProfType IN ( 'LE', 'SP', 'VP');
   
  IF @CanModify = 0  
    SET @ErrMsg = 'Du har ikke rettigheter til å endre medisinlisten'
END
GO