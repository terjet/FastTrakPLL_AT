SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetLongDuration]( @StudyId INT, @YearCount INT ) AS
BEGIN 

  SELECT p.PersonId, qt.Quantity AS NDV_DIAGNOSE_YYYY 
  INTO #temp1
  FROM dbo.Person p
  JOIN dbo.GetLastQuantityTable( 3486, GETDATE() ) qt ON qt.PersonId = p.PersonId  
  WHERE ( p.DOB < DATEADD( yyyy, -@YearCount, GETDATE() ) ) AND qt.Quantity >= 1900;
  
  --- Calculate duration
  SELECT PersonId, NDV_DIAGNOSE_YYYY, CONVERT(INT,DATEPART(YYYY,getdate())-t1.NDV_DIAGNOSE_YYYY) AS DiabetesDuration
  INTO #temp2 
  FROM #temp1 t1
  WHERE DATEPART(YYYY,getdate()) - NDV_DIAGNOSE_YYYY >= @YearCount;
  
  SELECT v.*, t2.DiabetesDuration,
  CONCAT( 'Varighet ', t2.DiabetesDuration, ' år' ) AS InfoText
  FROM #temp2 t2 
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId=t2.PersonId
  WHERE t2.DiabetesDuration >= @YearCount AND v.StudyId = @StudyId
  ORDER BY t2.DiabetesDuration DESC;
   
END
GO

GRANT EXECUTE ON [NDV].[GetLongDuration] TO [FastTrak]
GO