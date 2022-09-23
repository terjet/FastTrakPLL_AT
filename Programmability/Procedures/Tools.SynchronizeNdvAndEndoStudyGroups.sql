SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[SynchronizeNdvAndEndoStudyGroups] AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StudyIdNdv INT, @StudyIdEndo INT;
  DECLARE @SynchronizationEnabled BIT;
  SELECT @StudyIdNdv = s.StudyId FROM dbo.Study s WHERE s.StudyName = 'NDV'
  SELECT @StudyIdEndo = s.StudyId FROM dbo.Study s WHERE s.StudyName = 'ENDO'


  -- Check if synchronization is enabled locally
  SELECT @SynchronizationEnabled = s.BitValue FROM Config.Setting s
  WHERE s.Section = 'Tools.SynchronizeNdvAndEndoStudyGroups' AND s.KeyName = 'Enabled'
  IF (ISNULL(@SynchronizationEnabled, 0)) = 0
    RAISERROR ('Synchronization of groups and statuses has not been enabled in Config.Setting.', 16, 1);

  -- Step 1: Create the ENDO groups that are missing in NDV
  INSERT INTO dbo.StudyGroup ( StudyId, GroupName, CenterId, GroupId, GroupActive )
  SELECT agg1.*, ROW_NUMBER() OVER ( PARTITION BY 1 ORDER BY agg1.GroupName ) + MaxGroupId AS NewGroupId, agg3.GroupActive
  FROM
  (
    SELECT sndv.StudyId, sgendo.GroupName, sgendo.CenterId
    FROM dbo.StudyGroup sgendo 
    JOIN dbo.Study sendo ON sendo.StudyId = sgendo.StudyId AND sendo.StudName = 'ENDO'
    JOIN dbo.Study sndv ON sndv.StudName = 'NDV'

  EXCEPT

    SELECT sg.StudyId, sg.GroupName, sg.CenterId 
    FROM dbo.StudyGroup sg 
    JOIN dbo.Study s ON s.StudyId = sg.StudyId AND s.StudName = 'NDV'
  ) agg1
  JOIN
  (
    SELECT MAX(GroupId) AS MaxGroupId 
    FROM dbo.StudyGroup sg
    JOIN Study s ON s.StudyId = sg.StudyId AND s.StudName = 'NDV'
  ) agg2 ON 1 = 1
  JOIN
  (
    SELECT sg.CenterId, sg.GroupActive, sg.GroupName 
    FROM dbo.StudyGroup sg 
    JOIN dbo.Study s ON s.StudyId = sg.StudyId AND s.StudyName = 'ENDO'
  ) agg3 ON agg3.CenterId = agg1.CenterId AND agg3.GroupName = agg1.GroupName;

  -- Step 2: Synchronize all groups between ENDO and NDV with ENDO as master
  MERGE dbo.StudCase AS trg
  USING 
  ( 
    SELECT sc.PersonId, sgendo.GroupId AS GroupIdEndo, sgendo.GroupName, sgndv.GroupId AS ExpectedNdvGroupId, sndv.StudyId AS NdvStudyId
    FROM dbo.StudCase sc 
    JOIN dbo.Study s ON s.StudyId = sc.StudyId AND s.StudyName = 'ENDO'
    JOIN dbo.Study sndv ON sndv.StudyName = 'NDV'
    LEFT JOIN dbo.StudyGroup sgendo ON sgendo.StudyId = sc.StudyId AND sgendo.GroupId = sc.GroupId -- Kan bli NULL for avsluttede pasienter
    LEFT JOIN dbo.StudyGroup sgndv ON sgndv.StudyId = sndv.StudyId AND sgndv.GroupName = sgendo.GroupName AND sgndv.CenterId = sgendo.CenterId
   ) AS src ON src.PersonId = trg.PersonId AND src.NdvStudyId = trg.StudyId AND ISNULL(trg.GroupId,0) <> ISNULL(src.ExpectedNdvGroupId,0)
  WHEN MATCHED
  THEN UPDATE SET GroupId = src.ExpectedNdvGroupId;

  -- Step 3: Synchronize the patients' study statuses between ENDO and NDV with ENDO as master
  UPDATE ndv
  SET FinState = ndvStatus.StatusId
  FROM dbo.StudCase ndv
  JOIN dbo.StudCase endo ON endo.PersonId = ndv.PersonId AND endo.StudyId = @StudyIdEndo
  JOIN dbo.StudyStatus endoStatus ON endoStatus.StatusId = endo.StatusId AND endoStatus.StudyId = @StudyIdEndo
  JOIN dbo.StudyStatus ndvStatus ON ndvStatus.StatusText = endoStatus.StatusText AND ndvStatus.StudyId = @StudyIdNdv
  WHERE ndv.StudyId = @StudyIdNdv AND ndv.FinState <> ndvStatus.StatusId  
END
GO

GRANT EXECUTE ON [Tools].[SynchronizeNdvAndEndoStudyGroups] TO [Administrator]
GO