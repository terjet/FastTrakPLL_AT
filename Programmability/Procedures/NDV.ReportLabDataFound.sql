SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportLabDataFound]( @DiabetesType INT, @FirstDate DateTime = NULL, @LastDate DateTime = NULL ) AS
BEGIN

  -- Inclusion period
  IF @LastDate IS NULL SET @LastDate = DATEDIFF(DAY,0,GETDATE());
  IF @FirstDate IS NULL SET @FirstDate = DATEADD( month, -15, @LastDate );

  -- Collection periods for labdata is different from inclusion
  CREATE TABLE #Dates( LabClassId INT NOT NULL PRIMARY KEY, Months INT, StartDate DateTime, LabName VARCHAR(32) );
  INSERT INTO #Dates VALUES (  6, 15, @FirstDate, 'U-Albumin/kreatinin ratio' );
  -- INSERT INTO #Dates VALUES ( 22, 12, @FirstDate ); -- Hemoglobin
  INSERT INTO #Dates VALUES ( 34, 30, @FirstDate, 'S-Totalkolesterol' );
  INSERT INTO #Dates VALUES ( 35, 30, @FirstDate, 'S-LDL-kolesterol' );
  INSERT INTO #Dates VALUES ( 36, 30, @FirstDate, 'S-Triglyserider' );
  INSERT INTO #Dates VALUES ( 37, 30, @FirstDate, 'S-HDL-kolesterol' );
  INSERT INTO #Dates VALUES ( 1058, 15, @FirstDate, 'B-HbA1c' );
  INSERT INTO #Dates VALUES ( 49, 15, @FirstDate, 'S-Kreatinin' );
  INSERT INTO #Dates VALUES ( 1075, 15, @FirstDate, 'Pt-eGFR (CKD-EPI)' );        
  IF @DiabetesType=1
  BEGIN
    INSERT INTO #Dates VALUES ( 62, 60, @FirstDate, 'S-Kobalaminer' );
    INSERT INTO #Dates VALUES ( 83, 60, @FirstDate, 'S-TSH' );
  END;
  INSERT INTO #Dates VALUES ( 124, 30, @FirstDate, 'S-ALAT' );
  UPDATE #Dates SET StartDate  = DATEADD(month,-Months,@LastDate )

  -- Get caselist for everybody with NDV_TYPE (ItemId=3196) in period
  SELECT DISTINCT ce.PersonId INTO #CaseList 
  FROM dbo.ClinEvent ce 
  JOIN dbo.StudyGroup sg ON sg.StudyId=ce.StudyId AND sg.GroupId=ce.GroupId AND sg.GroupActive=1
  JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId=USER_ID()
  JOIN dbo.ClinDatapoint dp ON dp.EventId=ce.EventId AND dp.ItemId=3196
  WHERE ( ce.EventTime >= @FirstDate ) AND ( ce.EventTime < @LastDate ) AND ( dp.EnumVal = @DiabetesType );

  -- Get denominator
  DECLARE @Antall INT;
  SELECT @Antall = COUNT(*) FROM #CaseList;

  -- Count lab measurements done
  SELECT v.PersonId,lc.LabClassId,count(LabDate) as Antall
  INTO #PersonLabCount FROM #CaseList v
  JOIN dbo.LabData ld ON ld.PersonId=v.PersonId
  JOIN dbo.LabCode lc ON lc.LabCodeId=ld.LabCodeId
  JOIN #Dates d ON d.LabClassId=lc.LabClassId
  WHERE ( ld.LabDate > d.StartDate ) AND ( ld.LabDate < @LastDate )
  GROUP BY v.PersonId,lc.LabClassId;

  -- Aggregate data
  SELECT LabClassId,COUNT(*) as Teller
  INTO #FinalDataset
  FROM #PersonLabCount
  GROUP BY LabClassId;
  -- Get Result
  SELECT d.LabClassId,d.LabName AS FriendlyName,d.StartDate,d.Months,@LastDate AS StopDate,ISNULL(r.Teller,0) AS Teller,@Antall AS Nevner,
    CONVERT(DECIMAL(5,1),100*CONVERT(FLOAT,Teller)/CONVERT(FLOAT,@Antall),2) AS Andel 
  FROM #Dates d
  LEFT OUTER JOIN #FinalDataset r ON r.LabClassId=d.LabClassId
  ORDER BY d.LabClassId;
END
GO

GRANT EXECUTE ON [NDV].[ReportLabDataFound] TO [FastTrak]
GO