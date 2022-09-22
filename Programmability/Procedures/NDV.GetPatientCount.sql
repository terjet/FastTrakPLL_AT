SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPatientCount] AS
BEGIN
  SELECT PersonId,ISNULL(CONVERT(INT,dbo.GetLastQuantity(PersonId,'NDV_CONSENT')),-1) AS OrderNumber
    INTO #temp
    FROM ViewActiveCaseListStub v
    JOIN Study s ON s.StudyId=v.StudyId AND s.StudyName='NDV';
  SELECT mia.OrderNumber,SUBSTRING(mia.OptionText,1,16) as OptionText
    INTO #tempAnswer
    FROM MetaItemAnswer mia 
    JOIN MetaItem mi ON mi.ItemId=mia.ItemId AND mi.VarName='NDV_CONSENT';
  INSERT INTO #tempAnswer (OrderNumber,OptionText) VALUES( -1,'(ubesvart)');
  SELECT ta.OrderNumber,ta.OptionText,count(t.PersonId) AS PatientCount 
    FROM #temp t JOIN  #tempAnswer ta ON ta.OrderNumber=t.OrderNumber
    GROUP BY ta.OrderNumber,ta.OptionText ORDER BY ta.OrderNumber;
END
GO

GRANT EXECUTE ON [NDV].[GetPatientCount] TO [FastTrak]
GO