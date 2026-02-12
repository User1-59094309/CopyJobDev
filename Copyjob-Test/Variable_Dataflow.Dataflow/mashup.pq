[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "holidaydatacontainer_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "countryOrRegion", DestinationColumnName = "countryOrRegion"], [SourceColumnName = "holidayName", DestinationColumnName = "holidayName"], [SourceColumnName = "normalizeHolidayName", DestinationColumnName = "normalizeHolidayName"], [SourceColumnName = "isPaidTimeOff", DestinationColumnName = "isPaidTimeOff"], [SourceColumnName = "countryRegionCode", DestinationColumnName = "countryRegionCode"], [SourceColumnName = "date", DestinationColumnName = "date"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared holidaydatacontainer = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = WorkspaceID]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = LakehouseID]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "holidaydatacontainer", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 2", each [countryOrRegion] = Region)
in
  #"Filtered rows";
shared WorkspaceID = let
  WorkspaceId = Variable.ValueOrDefault("$(/**/dataflow-Variables/WorkspaceId)", "abbcf9d9-3731-4bb4-b31b-c392a269e590")
  in
  WorkspaceId;
shared LakehouseID = let
LakehouseID =
  Variable.ValueOrDefault("$(/\*\*/dataflow-Variables/LakehouseID)", "f127c096-89ec-4f96-aa24-983f30da2457")
  in
  LakehouseID;
shared Region = let
  Source = Variable.ValueOrDefault("$(/**/dataflow-Variables/Region)", "Germany")
  in
  Source;
shared holidaydatacontainer_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "abbcf9d9-3731-4bb4-b31b-c392a269e590"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "a4f0343e-3d56-4aac-8730-999d1b890043"]}[Data],
  TableNavigation = Navigation_2{[Item = "holidaydatacontainer", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
