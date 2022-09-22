SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [NDV].[EnkeltRegneark] AS
SELECT v.PersonId, v.DOB, v.FullName, DATEDIFF(year, v.DOB, GETDATE()) AS Alder, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_TYPE')) AS NDV_TYPE, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_CONSENT')) AS NDV_CONSENT, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'SYSBP')) AS SYSBT, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'DIABP')) AS DIABT, 
    dbo.GetLastLab(v.PersonId, 'HBA1C') AS [Lab.HbA1c], 
    dbo.GetLastLab(v.PersonId, 'LDL') AS [Lab.LDL], 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_DIAGNOSE_YYYY')) AS NDV_DIAGNOSE_YYY,
    ( SELECT COUNT(*) FROM OngoingTreatment WHERE PersonId=v.PersonId AND ( ATC LIKE 'C0[2789]%' 
    OR StartReason IN ( 'Høyt blodtrykk','Hypertensjon','Blodtrykk' ))) AS [DrugList.BpDrugs],
    
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_SMOKING')) AS V3227, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'ALKOHOL_PER_UKE')) AS V3986, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_HYPOGLYCEMIA')) AS V3351, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'DM_HYPOGLYC_MONTH')) AS V3220, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'GLUC_SELFMON')) AS V5715, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_INSULIN_DEVICE')) AS V4056, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_KETOACIDOSIS')) AS V3352, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_BPDRUGS')) AS V4079,
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_FOOT_SENS')) AS V4636, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_FOOT_PULSE')) AS V4637, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_EYESIGHT')) AS V3404, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_FOOT_ULCER')) AS V3218, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_AMPUTATION')) AS V3414, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_NEPHROPATHY')) AS V3415, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_RETINOPATHY')) AS V4087, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_CHD')) AS V3397, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_STROKE')) AS V3398, 
    CONVERT(INT,dbo.GetLastQuantity(v.PersonId, 'NDV_ARTERIAL_SURGERY')) AS V3417
FROM
 dbo.ViewActiveCaseListStub AS v JOIN dbo.Study AS s ON s.StudyId = v.StudyId AND s.StudyName = 'NDV'
GO