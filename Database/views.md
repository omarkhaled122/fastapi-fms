# Views

## `ongoing_trips` View

This view shows detailed information about all trips currently marked as 'Ongoing'. It joins trips with driver, vehicle, and location data to display full trip context.

```sql
CREATE VIEW ongoing_trips AS
SELECT 
    t.TripID,
    d.DriverID,
    CONCAT(d.FirstName, ' ', d.LastName) AS DriverName,
    d.LicenseNumber AS DriverLicense,
    d.Phone AS DriverPhone,
    v.VehicleID,
    v.PlateNumber AS VehiclePlate,
    CONCAT(v.Make, ', ', v.Model) AS Vehicle,
    t.StartTime,
    t.EndTime,
    CONCAT(origin.Address, ', ', origin.City) AS OriginLocation,
    CONCAT(destination.Address, ', ', destination.City) As EndLocation,
    CONCAT(t.Distance, ' ', 'KM') AS Distance
FROM
    trip t
        JOIN driver d ON t.DriverID = d.DriverID
        JOIN vehicle v ON t.VehicleID = v.VehicleID
        JOIN location origin ON t.OriginLocationID = origin.LocationID
        JOIN location destination ON t.DestinationLocationID = destination.LocationID
WHERE
	t.TripStatus = 'Ongoing';
```
---

## `all_trips` View

This view provides a full history of all trips regardless of their status, combining trip data with related driver, vehicle, and location details.

```sql
CREATE VIEW all_trips AS
SELECT 
    t.TripID,
    CONCAT(d.FirstName, ' ', d.LastName) AS DriverName,
    d.DriverID,
    d.LicenseNumber AS DriverLicense,
    d.Phone AS DriverPhone,
    v.VehicleID,
    v.PlateNumber AS VehiclePlate,
    CONCAT(v.Make, ', ', v.Model) AS Vehicle,
    t.StartTime,
    t.EndTime,
    CONCAT(origin.Address, ', ', origin.City) AS OriginLocation,
    CONCAT(destination.Address, ', ', destination.City) As EndLocation,
    CONCAT(t.Distance, ' ', 'KM') AS Distance,
    t.TripStatus
FROM
    trip t
        JOIN driver d ON t.DriverID = d.DriverID
        JOIN vehicle v ON t.VehicleID = v.VehicleID
        JOIN location origin ON t.OriginLocationID = origin.LocationID
        JOIN location destination ON t.DestinationLocationID = destination.LocationID;
```
---

## `past_trips` View

This view filters only trips that are no longer active — i.e., trips with a status other than 'Ongoing'.

```sql
CREATE VIEW past_trips AS
SELECT 
    t.TripID,
    CONCAT(d.FirstName, ' ', d.LastName) AS DriverName,
    d.DriverID,
    d.LicenseNumber AS DriverLicense,
    d.Phone AS DriverPhone,
    v.VehicleID,
    v.PlateNumber AS VehiclePlate,
    CONCAT(v.Make, ', ', v.Model) AS Vehicle,
    t.StartTime,
    t.EndTime,
    CONCAT(origin.Address, ', ', origin.City) AS OriginLocation,
    CONCAT(destination.Address, ', ', destination.City) As EndLocation,
    CONCAT(t.Distance, ' ', 'KM') AS Distance,
    t.TripStatus
FROM
    trip t
        JOIN driver d ON t.DriverID = d.DriverID
        JOIN vehicle v ON t.VehicleID = v.VehicleID
        JOIN location origin ON t.OriginLocationID = origin.LocationID
        JOIN location destination ON t.DestinationLocationID = destination.LocationID
WHERE
    t.TripStatus <> 'Ongoing';
```
---
## `available_vehicles` View

This view displays all vehicles that are currently marked as "Available" in the `vehicle` table.

```sql
CREATE VIEW available_vehicles AS 
SELECT
	*
FROM
	vehicle
WHERE
	VehicleStatus = 'Available';
```
---

## `vehicles_in_maintenance` View

This view displays all vehicles that are currently undergoing maintenance.

```sql
CREATE VIEW vehicles_in_maintenance AS 
SELECT
	*
FROM
	vehicle
WHERE
	VehicleStatus = 'In Maintenance';
```
---

#### `violations_details` View

This view joins violation records with their corresponding trip, vehicle, and driver details, filtering only those violations that occurred during a trip's time range.

```sql
CREATE VIEW violations_details AS 
SELECT
	v.ViolationID,
    v.Date,
    v.Description,
    v.PenaltyAmount,
    t.VehiclePlate,
    t.DriverLicense,
    t.DriverName,
    TripID
FROM
    violation v JOIN all_trips t ON
    v.VehicleID = t.VehicleID
WHERE
	v.Date BETWEEN t.StartTime AND EndTime;
```
---

## `all_maintenances` View

Shows all maintenance history for all vehicles, including cost, description, and mechanic info.

```sql
CREATE VIEW all_maintenances AS   
SELECT
	m.MaintenanceID,
    m.Date,
    v.VehicleID,
    v.PlateNumber AS VehiclePlate,
    CONCAT(v.Make, ', ', v.Model, ' ', v.Year) AS Vehicle,
	v.OdometerReading,
    m.Description,
    m.Cost,
    m.PerformedBy,
    m.MaintenanceStatus
FROM
	maintenance m JOIN vehicle v ON
    m.VehicleID = v.VehicleID;
```
---

## `ongoing_maintenances` View

Filters only the maintenance records that are currently ongoing.

```sql
CREATE VIEW ongoing_maintenances AS   
SELECT
	m.MaintenanceID,
    m.Date,
    v.VehicleID,
    v.PlateNumber AS VehiclePlate,
    CONCAT(v.Make, ', ', v.Model, ' ', v.Year) AS Vehicle,
	v.OdometerReading,
    m.Description,
    m.Cost,
    m.PerformedBy,
    m.MaintenanceStatus
FROM
	maintenance m JOIN vehicle v ON
    m.VehicleID = v.VehicleID
WHERE
    m.MaintenanceStatus = 'Ongoing';
```