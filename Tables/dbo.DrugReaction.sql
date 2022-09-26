CREATE TABLE [dbo].[DrugReaction] (
  [DRId] [int] IDENTITY,
  [DRDate] [datetime] NOT NULL,
  [DRFuzzy] [int] NOT NULL,
  [PersonId] [int] NOT NULL,
  [TreatId] [int] NULL,
  [ATC] [varchar](7) NULL,
  [DrugName] [varchar](256) NULL,
  [Severity] [tinyint] NULL,
  [Relatedness] [tinyint] NULL,
  [Resolved] [tinyint] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DrugReaction_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_DrugReaction_CreatedBy] DEFAULT (user_id()),
  [RiskScore] AS ([Severity]*(3)+[Relatedness]),
  [UpdatedAt] [datetime] NULL,
  [UpdatedBy] [int] NULL,
  [DeletedAt] [datetime] NULL,
  [DeletedBy] [int] NULL,
  [DescriptiveText] [varchar](max) NULL,
  [CaveId] [varchar](40) NULL,
  [LegemiddelId] [varchar](40) NULL,
  [VirkestoffId] [varchar](max) NULL,
  [HjelpestoffReaksjon] [bit] NULL,
  [GrunnlagForCAVE] [varchar](max) NULL,
  [Signatur] [varchar](200) NULL,
  [LegemiddelNavn] [varchar](max) NULL,
  [VirkestoffNavn] [varchar](max) NULL,
  [ReaksjonV] [int] NULL,
  [ReaksjonDN] [varchar](100) NULL,
  [KildeV] [int] NULL,
  [KildeDN] [varchar](100) NULL,
  [AlvorlighetsgradV] [varchar](1) NULL,
  [AlvorlighetsgradDN] [varchar](100) NULL,
  [SannsynlighetV] [int] NULL,
  [SannsynlighetDN] [varchar](100) NULL,
  [Avkreftet] [bit] NOT NULL CONSTRAINT [DF_DrugReaction_Avkreftet] DEFAULT (0),
  [Oppdaget_Alder] [int] NULL,
  [Oppdaget_IkkeOppgitt] [bit] NULL,
  [Oppdaget_Dato] [date] NULL,
  [Oppdaget_Ukjent] [bit] NULL,
  [Oppdaget] [varchar](100) NULL,
  CONSTRAINT [PK_DrugReaction] PRIMARY KEY CLUSTERED ([DRId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_DrugReaction_ATC]
  ON [dbo].[DrugReaction] ([ATC])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_DrugReaction_PersonId]
  ON [dbo].[DrugReaction] ([PersonId])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_DrugReaction_Update] ON [dbo].[DrugReaction]
AFTER UPDATE AS
BEGIN
 SET NOCOUNT ON;
 IF UPDATE( DRDate ) OR UPDATE( DRFuzzy ) OR UPDATE( DescriptiveText) OR UPDATE( Severity ) OR UPDATE( Relatedness ) OR UPDATE( Resolved ) OR UPDATE( DeletedAt ) OR UPDATE( DeletedBy ) 
  INSERT INTO dbo.DrugReactionLog ( DRId, DRDate, DRFuzzy, DescriptiveText, Severity, Relatedness, Resolved, ChangedAt, ChangedBy, DeletedAt, DeletedBy )
  SELECT DRId, DRDate, DRFuzzy, DescriptiveText, Severity, Relatedness, Resolved, GETDATE(), USER_ID(), DeletedAt, DeletedBy
  FROM deleted;  
END
GO

GRANT SELECT ON [dbo].[DrugReaction] TO [FastTrak]
GO

ALTER TABLE [dbo].[DrugReaction]
  ADD CONSTRAINT [FK_DrugReaction_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugReaction]
  ADD CONSTRAINT [FK_DrugReaction_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugReaction] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugReaction_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO

ALTER TABLE [dbo].[DrugReaction] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugReaction_Relatedness] FOREIGN KEY ([Relatedness]) REFERENCES [dbo].[MetaRelatedness] ([RelId])
GO

ALTER TABLE [dbo].[DrugReaction] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugReaction_Resolved] FOREIGN KEY ([Resolved]) REFERENCES [dbo].[MetaResolution] ([ResId])
GO

ALTER TABLE [dbo].[DrugReaction] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugReaction_Severity] FOREIGN KEY ([Severity]) REFERENCES [dbo].[MetaSeverity] ([SevId])
GO

ALTER TABLE [dbo].[DrugReaction]
  ADD CONSTRAINT [FK_DrugReaction_TreatId] FOREIGN KEY ([TreatId]) REFERENCES [dbo].[DrugTreatment] ([TreatId])
GO

ALTER TABLE [dbo].[DrugReaction]
  ADD CONSTRAINT [FK_DrugReaction_UpdatedBy] FOREIGN KEY ([UpdatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO