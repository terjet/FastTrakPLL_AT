SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetNationalIds]( @StudyName VARCHAR(40) ) AS
BEGIN
  SELECT NationalId FROM Person p 
    JOIN StudCase sc ON sc.PersonId=p.PersonId   
    JOIN StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.StatusId AND ss.StatusActive =1
    JOIN Study s ON s.StudyId=sc.StudyId AND s.StudName=@StudyName;
END
GO

GRANT EXECUTE ON [dbo].[GetNationalIds] TO [FastTrak]
GO