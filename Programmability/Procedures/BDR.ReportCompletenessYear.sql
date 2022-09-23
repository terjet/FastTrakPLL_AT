SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[ReportCompletenessYear]( @StudyId INT, @Year INT ) AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @FirstLabDate DATE = CONCAT(@Year - 1, '-12-01');
  DECLARE @LastLabAndFormDate DATE = CONCAT(@Year, '-12-31');


  SELECT * INTO #LipidTable FROM BDR.GetLipidTableByFormAndDateVariable( CONCAT( 'BDR_LABDATA_', @Year ), 10569 )

  SELECT CASE -- Vurder om pasienten er komplett
    WHEN ( cfCtrl.FormCompleteRequired IS NOT NULL AND cfCtrl.FormCompleteRequired = 100 ) AND -- Årskontroll
        ( CtrlFamHist.EnumVal IS NOT NULL AND ( CtrlFamHist.EnumVal = 2 OR -- Familieanamnese
          ( FamHist.FormCompleteRequired IS NOT NULL AND FamHist.FormCompleteRequired = 100 AND
          FamHist.SignedAt IS NOT NULL AND YEAR(FamHist.FormDate) = YEAR(FamHist.SignedAt) ) ) ) AND
        ( Insulin.FormCompleteRequired IS NOT NULL AND Insulin.FormCompleteRequired IN (-1, 100) AND -- Insulindosering
          Insulin.FormDate = CONVERT(DATE, ctrl.EventTime) ) AND
        ( ( ( cfLabData.FormCompleteRequired IS NOT NULL AND cfLabData.FormCompleteRequired = 100 ) AND -- Labskjema             
         ( HbA1cAker.Quantity IS NOT NULL AND chol.NumResult IS NOT NULL AND hdl.NumResult IS NOT NULL AND -- Labprøvar
          ldl.NumResult IS NOT NULL AND trig.NumResult IS NOT NULL AND LabDataSampling.EnumVal IS NOT NULL ) ) OR
           ( LabDataSampling.EnumVal IS NOT NULL AND LabDataSampling.EnumVal = 1 ) ) -- Ja på 10578 overstyrer resten av labskjema og labprøvar
      THEN
      CASE -- Sjekk U-ACR til sist
        WHEN ( LabDataSampling.EnumVal IS NOT NULL AND LabDataSampling.EnumVal = 1 ) THEN 1
        WHEN ( UACR1.Quantity IS NOT NULL AND UACR1.Quantity <= 3 ) THEN 1
        ELSE 
          CASE
            WHEN ( UACR2.Quantity IS NOT NULL AND UACR3.Quantity IS NOT NULL ) THEN 1
            ELSE 0
          END
      END
      ELSE 0
    END AS Complete,
    v.*,
    ctrl.ClinFormId AS CtrlClinFormId, ctrl.EventId AS CtrlEventId, ctrl.EventTime AS CtrlEventTime, ctrl.CreatedAt AS CtrlCreatedAt, ctrl.SignedAt AS CtrlSignedAt,
    LabDataSampling.EnumVal AS LabSamplingComplete,
    cfCtrl.FormCompleteRequired AS ControlComplete,
    CtrlFamHist.EnumVal AS FamilyHistoryChanged, YEAR(FamHist.FormDate) AS FamilyHistoryYear, FamHist.SignedAt AS FamilyHistorySignedAt,
    FamHist.FormCompleteRequired AS FamilyHistoryComplete,
    Insulin.FormCompleteRequired AS InsulinComplete,
    cfLabData.FormCompleteRequired AS LabDataComplete,
    HbA1cAker.Quantity AS HbA1cAker, UACR1.Quantity AS UACR1,
    UACR2.Quantity AS UACR2, UACR3.Quantity AS UACR3,
    chol.NumResult AS Cholesterol, hdl.NumResult AS HDL, ldl.NumResult AS LDL, trig.NumResult AS Triglycerides
      FROM dbo.ViewActiveCaseListStub v
  -- Skjema
  LEFT JOIN dbo.GetLastFormTableByName( CONCAT( 'BDR_YEAR_', @Year ), NULL ) ctrl ON ctrl.PersonId = v.PersonId
  LEFT JOIN dbo.ClinForm cfCtrl ON cfCtrl.ClinFormId = ctrl.ClinFormId
  LEFT JOIN dbo.ClinDataPoint CtrlFamHist ON CtrlFamHist.EventId = ctrl.EventId AND CtrlFamHist.ItemId = 10553  
  LEFT JOIN (
    SELECT DISTINCT ce.EventId, ce.StudyId, ce.PersonId, CONVERT(DATE, ce.EventTime) AS FormDate, cf.FormCompleteRequired, cf.SignedAt, cf.SignedBy
    FROM dbo.ClinEvent ce
    LEFT JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId
    LEFT JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND cf.DeletedAt IS NULL
    WHERE mf.FormName = 'BDR_FAMILY' 
    ) FamHist ON FamHist.PersonId = v.PersonId AND FamHist.FormDate = CONVERT(DATE, ctrl.EventTime) 
  LEFT JOIN (
    SELECT DISTINCT ce.EventId, ce.StudyId, ce.PersonId, CONVERT(DATE, ce.EventTime) AS FormDate, cf.FormCompleteRequired, cf.SignedAt, cf.SignedBy
    FROM dbo.ClinEvent ce
    LEFT JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
    LEFT JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
    WHERE mf.FormName = 'BDIA_INSULIN' 
    ) Insulin ON Insulin.PersonId = v.PersonId AND Insulin.FormDate = CONVERT(DATE, ctrl.EventTime) 
  LEFT JOIN dbo.GetLastFormTableByName( CONCAT( 'BDR_LABDATA_', @Year ), NULL ) LabData ON LabData.PersonId = v.PersonId
  LEFT JOIN dbo.ClinForm cfLabData ON cfLabData.ClinFormId = LabData.ClinFormId
  LEFT JOIN dbo.ClinDataPoint LabDataSampling ON LabDataSampling.EventId = LabData.EventId AND LabDataSampling.ItemId = 10578 
  -- Labdata
  LEFT JOIN dbo.ClinDataPoint HbA1cAker ON HbA1cAker.EventId = LabData.EventId AND LabData.PersonId = v.PersonId AND HbA1cAker.ItemId = 10454
  LEFT JOIN dbo.ClinDataPoint UACR1 ON UACR1.EventId = LabData.EventId AND LabData.PersonId = v.PersonId AND UACR1.ItemId = 10575  
  LEFT JOIN dbo.ClinDataPoint UACR2 ON UACR2.EventId = LabData.EventId AND LabData.PersonId = v.PersonId AND UACR2.ItemId = 10576
  LEFT JOIN dbo.ClinDataPoint UACR3 ON UACR3.EventId = LabData.EventId AND LabData.PersonId = v.PersonId AND UACR3.ItemId = 10577
  LEFT JOIN #LipidTable chol ON chol.PersonId = v.PersonId AND chol.LabClassId = 34
  LEFT JOIN #LipidTable hdl ON hdl.PersonId = v.PersonId AND hdl.LabClassId = 37
  LEFT JOIN #LipidTable ldl ON ldl.PersonId = v.PersonId AND ldl.LabClassId = 35
  LEFT JOIN #LipidTable trig ON trig.PersonId = v.PersonId AND trig.LabClassId = 36
  WHERE v.StudyId = @StudyId
  ORDER BY Complete, v.FullName;
END
GO

GRANT EXECUTE ON [BDR].[ReportCompletenessYear] TO [FastTrak]
GO