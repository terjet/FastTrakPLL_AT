SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[RemoveUnusedProcedures] AS
BEGIN

  SET NOCOUNT ON;                                  
  
  DROP PROCEDURE IF EXISTS Dash.BdrType1HbA1cAverage;
  DROP PROCEDURE IF EXISTS dbo.MetadataUpdate;
  DROP PROCEDURE IF EXISTS dbo.InitializeTarmscreening;
  DROP PROCEDURE IF EXISTS Report.FHIRMessageReport;
  DROP PROCEDURE IF EXISTS Tools.PrepareForFastTrak20;

  -- Obsolete populations and CDSS rules

  DROP PROCEDURE IF EXISTS dbo.GetGaseListInactiveGroup;
  DROP PROCEDURE IF EXISTS dbo.GetCaseListEkkoSubstudie;

  DROP PROCEDURE IF EXISTS GBD.GetCaseListMust;
  DROP PROCEDURE IF EXISTS GBD.GetCaseListNoBergerSixMonths;
  DROP PROCEDURE IF EXISTS GBD.RuleBerger;
  DROP PROCEDURE IF EXISTS GBD.RuleMUST;
  DROP PROCEDURE IF EXISTS GBD.UpdateMustScoreForAll;
      
  
  DROP PROCEDURE IF EXISTS NDV.GetCaseListType2WithCHD;
  DROP PROCEDURE IF EXISTS NDV.GetType1WithLDLAbove35Age40;
  DROP PROCEDURE IF EXISTS NDV.GetType2WIthLDLAbove25;
  DROP PROCEDURE IF EXISTS NDV.GetType2WithLDLAbove35;
  DROP PROCEDURE IF EXISTS NDV.GetType2WithLDLAbove35Age40;

  -- Consent is no longer relevant in NDV
  
  DROP PROCEDURE IF EXISTS NDV.GetCaseListUserVsConsent;
  DROP PROCEDURE IF EXISTS NDV.GetCaseListConsentVisits
  DROP PROCEDURE IF EXISTS NDV.GetCaseListConsentNegative
  DROP PROCEDURE IF EXISTS NDV.GetCaseListConsentUnknown
  DROP PROCEDURE IF EXISTS NDV.GetType1WithoutConsent;
  DROP PROCEDURE IF EXISTS NDV.GetType2WithoutConsent;
  DROP PROCEDURE IF EXISTS NDV.GetType34WithoutConsent;
  DROP PROCEDURE IF EXISTS NDV.GetType5WithoutConsent;
  DROP PROCEDURE IF EXISTS NDV.ReportConsentStatus;
  DROP PROCEDURE IF EXISTS NDV.RuleConsent;
  DROP PROCEDURE IF EXISTS Dash.NdvType1Consent;         
  
  
  -- ROAS does not use dashboard
  
  DROP PROCEDURE IF EXISTS Dash.RoasGroupCount;              
  
  -- Replaced with DIA.GetCaseListCGM
  
  DROP PROCEDURE IF EXISTS NDV.GetCaseListCGM;
  DROP PROCEDURE IF EXISTS BDR.GetCaseListCGM;

  --  To find candidates to delete from DbProcList, run this query:
  --  SELECT DISTINCT ProcName FROM dbo.DbProcList WHERE OBJECT_ID(ProcName) IS NULL;  

  DELETE FROM dbo.DbProcList WHERE ProcName IN 
   ( 'Report.FHIRMessageReport', 'dbo.InitializeTarmscreening', 'Dash.NdvType1Consent', 
     'Dash.RoasGroupCount', 'Tools.PrepareForFastTrak20', 'Dash.BdrType1HbA1cAverage',
     'dbo.GetCaseListEkkoSubstudie', 'GBD.GetCaseListMust','TBD.GetCaseListNoBergerSixMonths',
     'GBD.RuleBerger','GBD.RuleMUST','GBD.UpdateMustScoreForAll','NDV.GetCaseListConsentNegative',
     'NDV.GetCaseListConsentUnknown','NDV.GetCaseListConsentVisits','NDV.GetCaseListType2WithCHD',
     'NDV.GetType1WithLDLAbove35Age40','NDV.GetType1WithoutConsent','NDV.GetType2WIthLDLAbove25',
     'NDV.GetType2WithLDLAbove35','NDV.GetType2WithLDLAbove35Age40','NDV.GetType2WithoutConsent',
     'NDV.GetType34WithoutConsent','NDV.GetType5WithoutConsent','NDV.ReportConsentStatus','NDV.RuleConsent',
     'NDV.GetCaseListUserVsConsent');

-- FHIR Lab related, moved to schema LAB.
  
  DROP PROCEDURE IF EXISTS NDV.StartBeakerImport;
  DROP PROCEDURE IF EXISTS NDV.FinishBeakerImport;
  DROP PROCEDURE IF EXISTS dbo.GetLoincCodes;
    
END
GO

GRANT EXECUTE ON [Tools].[RemoveUnusedProcedures] TO [Administrator]
GO