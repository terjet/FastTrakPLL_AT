CREATE TABLE [dbo].[MetaTreatPackGroup] (
  [TreatType] [char](1) NOT NULL,
  [PackType] [char](1) NOT NULL,
  [GroupName] [varchar](24) NOT NULL,
  [SortOrder] [tinyint] NOT NULL,
  [ValidCombo] [tinyint] NOT NULL,
  CONSTRAINT [PK_MetaPackGroup] PRIMARY KEY CLUSTERED ([TreatType], [PackType])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaTreatPackGroup] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaTreatPackGroup]
  ADD CONSTRAINT [FK_MetaTreatPackGroup_PackType] FOREIGN KEY ([PackType]) REFERENCES [dbo].[MetaPackType] ([PackType])
GO

ALTER TABLE [dbo].[MetaTreatPackGroup]
  ADD CONSTRAINT [FK_MetaTreatPackGroup_TreatType] FOREIGN KEY ([TreatType]) REFERENCES [dbo].[MetaTreatType] ([TreatType])
GO