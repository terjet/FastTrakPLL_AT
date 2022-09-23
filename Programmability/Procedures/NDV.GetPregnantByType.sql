SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPregnantByType]( @StudyId INT, @DiaType INT = NULL ) AS
BEGIN

 SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, p.GenderId, a.GroupName, p.NationalId, 
 InfoText = 
   CONCAT( 
     CASE a.DiaType 
        WHEN 1 THEN 'Type 1'
        WHEN 2 THEN 'Type 2'
        WHEN 5 THEN 'Svangerskapsdiabetes'
        ELSE 'Andre typer' 
     END,
    ', termin ', 
    COALESCE( CONVERT( VARCHAR, ulyd.DTVal, 104 ), '(ukjent)' ), '.'
  )
  FROM 
  (
    SELECT 
      sc.PersonId,
      sg.CenterId, sg.GroupId, sg.GroupName, 
      sc.StudyId, sc.FinState,
      cdp.EnumVal AS DiaType, ce.EventTime,
      ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY ce.EventTime DESC ) AS OrderNo 
    FROM dbo.ClinForm cf
      JOIN dbo.ClinEvent ce ON ( ce.EventId = cf.EventId )
      JOIN dbo.ClinDatapoint cdp ON cdp.EventId=ce.EventId AND cdp.ItemId = 3196
      JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
      JOIN dbo.StudCase sc ON ( sc.StudyId = ce.StudyId ) AND ( sc.PersonId = ce.PersonId )
      JOIN dbo.Person p ON ( p.PersonId=sc.PersonId )
      JOIN dbo.StudyGroup sg ON ( sg.StudyId = ce.StudyId ) AND ( sg.GroupId = ce.GroupId )
      JOIN dbo.UserList my ON ( my.UserId = USER_ID() )
    WHERE ( cf.DeletedAt IS NULL )
      AND ( mf.FormName ='DIAPOL_GRAVIDE' )
      AND ( sg.CenterId = my.CenterId ) 

  ) a
  JOIN dbo.Person p ON p.PersonId = a.PersonId
  LEFT JOIN dbo.GetLastDateTable( 4221, GETDATE() ) ulyd ON ulyd.PersonId = a.PersonId 
  WHERE ( a.OrderNo = 1 ) AND ( ISNULL( a.DiaType, @DiaType ) = @DiaType )
  ORDER BY ulyd.DTVal, p.ReverseName;
  
END
GO

GRANT EXECUTE ON [NDV].[GetPregnantByType] TO [FastTrak]
GO