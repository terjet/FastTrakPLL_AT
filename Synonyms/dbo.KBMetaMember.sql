CREATE SYNONYM [dbo].[KBMetaMember] FOR [FEST].[GroupMember]
GO

GRANT
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[KBMetaMember] TO [Administrator]
GO

GRANT SELECT ON [dbo].[KBMetaMember] TO [FastTrak]
GO