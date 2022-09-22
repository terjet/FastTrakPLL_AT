SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetPersons] AS
BEGIN
	SELECT PersonId, DOB, FstName, MidName, LstName, GenderId, NationalId, FullName, Initials, ReverseName, GSM, HPRNo, DeceasedInd, TestCase
	FROM dbo.Person;
END;
GO