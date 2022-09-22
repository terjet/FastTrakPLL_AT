SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetUserStudyCenter]( @UserId INT ) AS
BEGIN
    SELECT ul.CenterId, c.CenterName, c.CenterActive
    FROM dbo.UserList ul
    JOIN dbo.StudyCenter c ON c.CenterId = ul.CenterId
    WHERE ul.UserId = @UserId;
END;
GO