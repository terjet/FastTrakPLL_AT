SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaStudyForm]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  UPDATE dbo.MetaStudyForm SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching dbo.MetaStudyForm

  SELECT x.r.value('@StudyFormId', 'int') AS StudyFormId,
    x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@FormTitle', 'varchar(128)') AS FormTitle,
    x.r.value('@StudyName', 'varchar(40)') AS StudyName,
    x.r.value('@ParentId', 'int') AS ParentId,
    x.r.value('@Repeatable', 'bit') AS Repeatable,
    x.r.value('@SurveyStatus', 'varchar(6)') AS SurveyStatus,
    x.r.value('@HideComment', 'tinyint') AS HideComment,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaStudyForm/Row') AS x (r);

  -- Merge temporary table into dbo.MetaStudyForm on StudyFormId as key.

  MERGE INTO dbo.MetaStudyForm msf USING ( SELECT t.*,s.StudyId FROM #temp t JOIN dbo.Study s ON s.StudyName=t.StudyName ) xd ON (msf.StudyFormId = xd.StudyFormId)

  WHEN MATCHED 
    THEN UPDATE 
    SET msf.FormId = xd.FormId,
	    msf.StudyId = xd.StudyId,
        msf.FormTitle = xd.FormTitle,
        msf.SurveyStatus = xd.SurveyStatus,
        msf.ParentId = xd.ParentId,
        msf.Repeatable = xd.Repeatable,
        msf.HideComment = xd.HideCOmment,
        msf.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN 
      INSERT (StudyFormId, StudyId, FormId, FormTitle, SurveyStatus, Repeatable, ParentId, HideComment, LastUpdate) 
        VALUES (xd.StudyFormId, xd.StudyId, xd.FormId, xd.FormTitle, xd.SurveyStatus, xd.Repeatable, xd.ParentId, xd.HideComment, xd.LastUpdate);

 DELETE FROM  dbo.MetaStudyForm WHERE LastUpdate = '1980-01-01';

END;
GO