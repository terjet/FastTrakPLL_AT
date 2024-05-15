SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
	CREATE PROCEDURE [Drug].[ReportDrugReactionChanges]( @PersonIdNum int ) AS
	BEGIN
		select *, ROW_NUMBER() over ( Partition by drId order by ChangedAt ) as SortedOrder
		  into #drLog
		  from 
		  ( 
			select	drl.DRId, drl.ChangedAt, 
					USER_NAME(drl.ChangedBy) as UserName, 
					drl.DescriptiveText, 
					drl.Severity, 
					drl.Relatedness
				from DrugReaction dr 
			join DrugReactionLog drl on drl.DRId = dr.DRId
			join dbo.MetaSeverity sev on sev.SevId = drl.Severity
			where dr.PersonId =	@PersonIdNum 
			union
			select	drId, 
					IsNull(UpdatedAt, GetDate() ), 
					USER_NAME(updatedby), 
					DescriptiveText, 
					Severity, 
					Relatedness
			from dbo.DrugReaction where PersonId = @PersonIdNum
		  ) as tempdata order by ChangedAt;

		select
      drlog1.DRId,
      dr.DrugName,
			ms1.SevName as OldSeverity, 
			ms2.SevName as NewSeverity,
			mr1.RelName as OldRelation,
			mr2.RelName as NewRelation,
			drlog1.ChangedAt, 
			drlog1.DescriptiveText as OldDescription,
			drlog2.DescriptiveText as NewDescription,
			drlog2.UserName as ChangedBy
		from #drLog drlog1
		JOIN dbo.MetaSeverity Ms1 on Ms1.SevId = drlog1.Severity
		JOIN dbo.MetaRelatedness Mr1 on Mr1.RelId = drlog1.Relatedness
    JOIN dbo.DrugReaction dr ON dr.DRId = drlog1.DRId
		LEFT JOIN #drLog drlog2 on drlog2.DRId = drlog1.DRId and drlog2.SortedOrder = drlog1.SortedOrder +1
		LEFT JOIN dbo.MetaSeverity Ms2 on Ms2.SevId = drlog2.Severity
		LEFT JOIN dbo.MetaRelatedness Mr2 on Mr2.RelId = drlog2.Relatedness
    WHERE 
      ( CHECKSUM(drLog1.Severity, drlog1.Relatedness, drlog1.DescriptiveText ) <> CHECKSUM(drlog2.Severity, drlog2.Relatedness, drLog2.DescriptiveText ) )
      AND ( drlog2.DRId IS NOT NULL )
    ORDER BY drlog1.DrId, drlog1.ChangedAt;
	End;
GO

GRANT EXECUTE ON [Drug].[ReportDrugReactionChanges] TO [FastTrak]
GO