SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseHistory] AS
BEGIN
  DECLARE @XmlData XML;
  SET @XmlData = ( 
    SELECT Person.NationalId,History.* FROM StudyCaseGroupStatusHistory History 
    JOIN dbo.Person Person ON Person.PersonId=History.PersonId 
    JOIN dbo.StudCase sc ON sc.PersonId=Person.PersonId AND sc.MarkedForExport=1
    ORDER BY Person.PersonId FOR XML AUTO);
  SELECT CONVERT(VARCHAR(max),@XmlData) AS XmlData;
END
GO