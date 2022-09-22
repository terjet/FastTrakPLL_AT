SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabReqTestAllPending]( @IncludeTaken INT, @UserId INT ) AS
SET NOCOUNT ON;
SELECT vrp.PersonId,p.DOB,
  RTRIM(p.LstName + ', ' + p.fstName + ' ' + ISNULL(MidName,'')) as PersonName,
  vrp.LabCodeId,lc.LabName,
  vrp.LabReqId,
  vrp.RequestedAt,vrp.RequestedBy,USER_NAME(vrp.RequestedBy) as RequestedByUser,
  vrp.TakenAt,vrp.TakenBy,USER_NAME(vrp.TakenBy) AS TakenByUser
FROM ViewLabReqPending vrp
JOIN LabCode lc ON lc.LabCodeId=vrp.LabCodeId
JOIN Person p on p.PersonId=vrp.PersonId
WHERE (( @IncludeTaken = 1) OR (vrp.TakenAt IS NULL) )
AND ((vrp.RequestedBy=@UserId) or ( @UserId=0 ) )
GO