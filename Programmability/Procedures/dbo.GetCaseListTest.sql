﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListTest]( @StudyId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Person SET TestCase = 1 WHERE NationalId IN 
  ( '15076500565','21016400952','12057900499','13116900216','14019800513',
    '70019950032','05073500186','70019950032','02039000183','08077000292',
    '15040650560','21030550231','12050050295','02027311027','24019494930' );
  SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, 'Test' AS GroupName, p.GenderId, p.NationalId,
    'Testperson' AS InfoText
  FROM dbo.Person p
  WHERE p.TestCase = 1
  ORDER BY p.FullName;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListTest] TO [FastTrak]
GO