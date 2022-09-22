SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListUnwrittenRx]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,convert(varchar,dp.CreatedAt,104) + ' - ' + dt.DrugName AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.DrugTreatment dt ON dt.PersonId=v.PersonId
  JOIN dbo.DrugPrescription dp ON dp.TreatId=dt.TreatId
  WHERE v.StudyId=@StudyId AND dp.PrintedAt IS NULL AND dp.DeletedAt IS NULL
  ORDER BY dp.CreatedAt DESC
END
GO