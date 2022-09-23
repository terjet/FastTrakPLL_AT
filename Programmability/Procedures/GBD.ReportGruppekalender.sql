SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[ReportGruppekalender] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, RoomNumber.TextVal AS RoomNumber,
    MondayMorning.TextVal AS MondayMorn, MondayAfternoon.TextVal AS MondayAftern,
    TuesdayMorning.TextVal AS TuesdayMorn, TuesdayAfternoon.TextVal AS TuesdayAftern,
    WednesdayMorning.TextVal AS WednesdayMorn, WednesdayAfternoon.TextVal AS WednesdayAftern,
    ThursdayMorning.TextVal AS ThursdayMorn, ThursdayAfternoon.TextVal AS ThursdayAftern,
    FridayMorning.TextVal AS FridayMorn, FridayAfternoon.TextVal AS FridayAftern,
    SaturdayMorning.TextVal AS SaturdayMorn, SaturdayAfternoon.TextVal AS SaturdayAftern,
    SundayMorning.TextVal AS SundayMorn, SundayAfternoon.TextVal AS SundayAftern
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastTextValuesTable(3673, NULL) RoomNumber ON v.PersonId = RoomNumber.PersonId
  LEFT JOIN dbo.GetLastFormTableByName ('GBD_AKTIVITETSKALENDER', NULL) Aktivitetskalender ON Aktivitetskalender.PersonId = v.PersonId
  LEFT JOIN dbo.ClinDataPoint MondayMorning ON MondayMorning.EventId = Aktivitetskalender.EventId AND MondayMorning.ItemId = 3026
  LEFT JOIN dbo.ClinDataPoint MondayAfternoon ON MondayAfternoon.EventId = Aktivitetskalender.EventId AND MondayAfternoon.ItemId = 3178
  LEFT JOIN dbo.ClinDataPoint TuesdayMorning ON TuesdayMorning.EventId = Aktivitetskalender.EventId AND TuesdayMorning.ItemId = 3173
  LEFT JOIN dbo.ClinDataPoint TuesdayAfternoon ON TuesdayAfternoon.EventId = Aktivitetskalender.EventId AND TuesdayAfternoon.ItemId = 3186
  LEFT JOIN dbo.ClinDataPoint WednesdayMorning ON WednesdayMorning.EventId = Aktivitetskalender.EventId AND WednesdayMorning.ItemId = 3174
  LEFT JOIN dbo.ClinDataPoint WednesdayAfternoon ON WednesdayAfternoon.EventId = Aktivitetskalender.EventId AND WednesdayAfternoon.ItemId = 3190
  LEFT JOIN dbo.ClinDataPoint ThursdayMorning ON ThursdayMorning.EventId = Aktivitetskalender.EventId AND ThursdayMorning.ItemId = 3175
  LEFT JOIN dbo.ClinDataPoint ThursdayAfternoon ON ThursdayAfternoon.EventId = Aktivitetskalender.EventId AND ThursdayAfternoon.ItemId = 3191
  LEFT JOIN dbo.ClinDataPoint FridayMorning ON FridayMorning.EventId = Aktivitetskalender.EventId AND FridayMorning.ItemId = 3176
  LEFT JOIN dbo.ClinDataPoint FridayAfternoon ON FridayAfternoon.EventId = Aktivitetskalender.EventId AND FridayAfternoon.ItemId = 3282
  LEFT JOIN dbo.ClinDataPoint SaturdayMorning ON SaturdayMorning.EventId = Aktivitetskalender.EventId AND SaturdayMorning.ItemId = 3300
  LEFT JOIN dbo.ClinDataPoint SaturdayAfternoon ON SaturdayAfternoon.EventId = Aktivitetskalender.EventId AND SaturdayAfternoon.ItemId = 3301
  LEFT JOIN dbo.ClinDataPoint SundayMorning ON SundayMorning.EventId = Aktivitetskalender.EventId AND SundayMorning.ItemId = 3302
  LEFT JOIN dbo.ClinDataPoint SundayAfternoon ON SundayAfternoon.EventId = Aktivitetskalender.EventId AND SundayAfternoon.ItemId = 3303
  WHERE v.StudyId = @StudyId
  ORDER BY v.GroupName, RoomNumber.TextVal, v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[ReportGruppekalender] TO [FastTrak]
GO