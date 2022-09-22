SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListType2WithCHD]( @StudyId INT ) AS
BEGIN  
  SELECT PersonId,DOB,FullName,GroupName,'Koronarsyk siden ' + 
  ISNULL(SUBSTRING(CONVERT(VARCHAR,dbo.GetLastQuantity( PersonId, 'NDV_CHD_DEBUT' )),1,4),'?') as InfoText 
  FROM NDV.Type2 WHERE ( Age >= 50 ) AND ( dbo.GetLastQuantity( PersonId, 'NDV_CHD' ) = 1 ) 
  ORDER BY FullName
END
GO