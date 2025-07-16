# Database System

## Tables Creation

```sql
CREATE TABLE driver (
    DriverID INTEGER PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    LicenseNumber VARCHAR(20) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(50),
    HireDate DATE DEFAULT (CURRENT_DATE),
    
    CHECK (Email LIKE '%@%.%')
);

CREATE TABLE vehicle (
    VehicleID INTEGER PRIMARY KEY,
    PlateNumber VARCHAR(20) UNIQUE NOT NULL,
    Make VARCHAR(20) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    Year INTEGER,
    VehicleStatus ENUM('Available', 'In Maintenance', 'In Trip', 'Unavailable') NOT NULL DEFAULT 'Available',
    OdometerReading INTEGER
);

CREATE TABLE location (
    LocationID INTEGER PRIMARY KEY,
    Address VARCHAR(50),
    City VARCHAR(20),
    Country VARCHAR(20)
);
 
CREATE TABLE trip (
    TripID INTEGER AUTO_INCREMENT PRIMARY KEY,
    DriverID INTEGER NOT NULL,
    VehicleID INTEGER NOT NULL,
    OriginLocationID INTEGER,
    DestinationLocationID INTEGER,
    StartTime DATETIME DEFAULT (CURRENT_TIMESTAMP),
    EndTime DATETIME DEFAULT '9999-12-31 23:59:59',
    Distance FLOAT,
    TripStatus ENUM('Ongoing', 'Completed', 'Canceled') NOT NULL DEFAULT 'Ongoing',

    FOREIGN KEY (DriverID) REFERENCES driver(DriverID),
    FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID),
    FOREIGN KEY (OriginLocationID) REFERENCES location(LocationID) ON DELETE SET NULL,
    FOREIGN KEY (DestinationLocationID) REFERENCES location(LocationID) ON DELETE SET NULL
);

CREATE TABLE fuellog (
    FuelLogID INTEGER AUTO_INCREMENT PRIMARY KEY,
    VehicleID INTEGER NOT NULL,
    Date DATE DEFAULT DATE((CURRENT_TIMESTAMP)),
    FuelType ENUM('Gasoline', 'Diesel', 'Electric'),
    Quantity FLOAT,
    Cost DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID) ON DELETE CASCADE

);

CREATE TABLE maintenance (
    MaintenanceID INTEGER AUTO_INCREMENT PRIMARY KEY,
    VehicleID INTEGER NOT NULL,
    Description TEXT,
    Date DATETIME DEFAULT (CURRENT_TIMESTAMP),
    Cost DECIMAL(10, 2) NOT NULL,
    PerformedBy ENUM(
                    'Midas',
                    'Meineke Car Care Centers',
                    'Christian Brothers Automotive',
                    'AAMCO Transmissions',
                    'CARSTAR',
                    'Jiffy Lube',
                    'Firestone Complete Auto Care',
                    'Monro, Inc.',
                    'NTB',
                    'Big O Tires'
                ),

    MaintenanceStatus ENUM('Ongoing', 'Completed', 'Canceled') NOT NULL DEFAULT 'Ongoing',
    
    FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID) ON DELETE CASCADE
);

  

CREATE TABLE violation (
    ViolationID INTEGER AUTO_INCREMENT PRIMARY KEY,
    VehicleID INTEGER NOT NULL,
    Date DATETIME DEFAULT (CURRENT_TIMESTAMP),
    Description TEXT,
    PenaltyAmount DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID) ON DELETE CASCADE

);
```
---

## Indexes
**trip_driver_idx:** It is created on **DriverID** in the **trip** table to enable searching trips by the driver id efficiently.
```sql
CREATE INDEX trip_driver_idx
ON trip(DriverID);
```

**trip_vehicle_idx:** It is created on **VehicleID** in the **trip** table to enable searching trips by the vehicle id efficiently.
```sql
CREATE INDEX trip_vehicle_idx
ON trip(VehicleID);
```

**trip_day_idx:** It is a Functional index created on **StartTime** in the **trip** table to enable searching trips by days efficiently using the function **DAY()**.
```sql
CREATE INDEX trip_day_idx
ON trip((DAY(StartTime))); 
```

**fuellog_vehicle_idx:** It is created on **VehicleID** in the **fuellog** table to enable searching the logs by vehicle id efficiently.
```sql
CREATE INDEX fuellog_vehicle_idx
ON fuellog(VehicleID);
```

**maintenance_vehicle_idx:** It is created on **VehicleID** in the **maintenance** table to enable searching maintenance logs by vehicle id efficiently.
```sql
CREATE INDEX maintenance_vehicle_idx
ON maintenance(VehicleID);
```

**violation_vehicle_idx:** It is created on **VehicleID** in the **violation** table to enable searching the violations by vehicle id efficiently.
```sql
CREATE INDEX violation_vehicle_idx
ON violation(VehicleID);
```

**violation_day_idx:** It is a Functional index created on **Date** in the **violatoin** table to enable searching the violations by days efficiently using the function **DAY()**.
```sql
CREATE INDEX violation_day_idx
ON violation((DAY(Date)));
```
---

## Views

#### `ongoing_trips` View

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

#### `all_trips` View

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

#### `past_trips` View

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
#### `available_vehicles` View

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

#### `vehicles_in_maintenance` View

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

#### `all_maintenances` View

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

#### `ongoing_maintenances` View

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
---

## Stored Functions

#### `get_vehicle_status(vehicle_id INT)`

Returns the current status (`Available`, `In Trip`, `In Maintenance`, `Unavailable`) of a specific vehicle.

```sql
DELIMITER //

CREATE FUNCTION get_vehicle_status(vehicle_id INT)
RETURNS VARCHAR(20)
NOT DETERMINISTIC
BEGIN
	DECLARE v_status VARCHAR(20);
    
    SELECT VehicleStatus INTO v_status
	FROM vehicle
	WHERE VehicleID = vehicle_id;
	
    RETURN v_status;
END//

DELIMITER ;
```

#### `get_trip_status(trip_id INT)`

Returns the current status of a specific trip (`Ongoing`, `Completed`, `Canceled`).

```sql
DELIMITER //

CREATE FUNCTION get_trip_status(trip_id INT)
RETURNS VARCHAR(20)
NOT DETERMINISTIC
BEGIN
	DECLARE t_status VARCHAR(20);
    
    SELECT TripStatus INTO t_status
	FROM trip
	WHERE TripID = trip_id;
	
    RETURN t_status;
END//

DELIMITER ;
```

#### `get_maintenance_status(maintenance_id INT)`

Returns the status of a specific maintenance record (`Ongoing`, `Completed`, `Canceled`).

```sql
DELIMITER //

CREATE FUNCTION get_maintenance_status(maintenance_id INT)
RETURNS VARCHAR(20)
NOT DETERMINISTIC
BEGIN
	DECLARE m_status VARCHAR(20);
    
    SELECT MaintenanceStatus INTO m_status
	FROM maintenance
	WHERE MaintenanceID = maintenance_id;
	
    RETURN m_status;
END//

DELIMITER ;
```
#### `distance_level(distance FLOAT)`

Classifies a numeric distance into categories: `Very Short`, `Short`, `Long`, or `Very Long`.

```sql
DELIMITER //

CREATE FUNCTION distance_level(distance FLOAT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE d_level VARCHAR(10);

    SET d_level =
        CASE
            WHEN distance <= 5 THEN 'Very Short'
            WHEN distance <= 20 THEN 'Short'
            WHEN distance <= 50 THEN 'Long'
            ELSE 'Very Long'
        END;

    RETURN d_level;
END//

DELIMITER ;
```

---

## Stored Procedures

#### `GetTripDistanceLevel(trip_id INT, OUT trip_distance_level VARCHAR(10))`

Finds a specific trip's distance by it's id and classifies it using `distance_level()`.

```sql
DELIMITER //

CREATE PROCEDURE GetTripDistanceLevel(
    IN  trip_id INTEGER,  
    OUT trip_distance_level VARCHAR(10)
)
BEGIN
	DECLARE trip_distance FLOAT DEFAULT 0;
    
    SELECT Distance INTO trip_distance
    FROM trip
    WHERE TripID = trip_id;
    
    SET trip_distance_level = distance_level(trip_distance);
END//

DELIMITER ;
```

#### `GetDriverTrips(driver_id INT)`

Returns all trips assigned to a specific driver.

```sql
DELIMITER //

CREATE PROCEDURE GetDriverTrips(
    IN  driver_id INTEGER  
)
BEGIN
    SELECT *
    FROM all_trips
    WHERE DriverID = driver_id;
END//

DELIMITER ;
```

#### `GetVehicleMaintenanceHistory(vehicle_id INT)`

Fetches the maintenance history of a specific vehicle.

```sql
DELIMITER //

CREATE PROCEDURE GetVehicleMaintenanceHistory(
    IN  vehicle_id INTEGER  
)
BEGIN
    SELECT *
    FROM all_maintenances
    WHERE VehicleID = vehicle_id;
END//

DELIMITER ;
```

---

## Triggers

#### `before_trip_insert`

Prevents inserting a new trip if the assigned vehicle is not available.

```sql
DELIMITER //

CREATE TRIGGER before_trip_insert
BEFORE INSERT ON trip
FOR EACH ROW
BEGIN    
    IF get_vehicle_status(NEW.VehicleID) = 'In Maintenance' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign trip: Vehicle In Maintenance';
    END IF;

    IF get_vehicle_status(NEW.VehicleID) = 'In Trip' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign trip: Vehicle In Trip';
    END IF;

    IF get_vehicle_status(NEW.VehicleID) = 'Unavailable' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign trip: Vehicle Unavailable';
    END IF;   
END//

DELIMITER ;
```


#### `after_trip_insert`

Updates the vehicle's status to `In Trip` after a trip is started.

```sql
DELIMITER //

CREATE TRIGGER after_trip_insert
AFTER INSERT ON trip
FOR EACH ROW
BEGIN
    IF NEW.TripStatus = 'Ongoing' THEN
        UPDATE vehicle 
        SET VehicleStatus = 'In Trip'
        WHERE VehicleID = NEW.VehicleID;
    END IF;
END//

DELIMITER ;
```



#### `before_trip_update`

Automatically sets the `EndTime` when a trip is marked as `Completed` or `Canceled`.

```sql
DELIMITER //

CREATE TRIGGER before_trip_update 
BEFORE UPDATE ON trip
FOR EACH ROW
BEGIN
    IF NEW.TripStatus = 'Completed' OR NEW.TripStatus = 'Canceled' THEN
        SET NEW.EndTime = CURRENT_TIMESTAMP;
    END IF;
END//

DELIMITER ;
```



#### `after_trip_update`

Marks the vehicle as `Available` after the trip ends.

```sql
DELIMITER //

CREATE TRIGGER after_trip_update 
AFTER UPDATE ON trip
FOR EACH ROW
BEGIN
    IF NEW.TripStatus = 'Completed' OR NEW.TripStatus = 'Canceled' THEN
        UPDATE vehicle
        SET VehicleStatus = 'Available'
        WHERE VehicleID = NEW.VehicleID;
    END IF;
END//

DELIMITER ;
```



#### `after_maintenance_insert`

Marks the vehicle as `In Maintenance` after inserting a new ongoing maintenance record.

```sql
DELIMITER //

CREATE TRIGGER after_maintenance_insert
AFTER INSERT ON maintenance
FOR EACH ROW
BEGIN
    IF NEW.MaintenanceStatus = 'Ongoing' THEN
        UPDATE vehicle 
        SET VehicleStatus = 'In Maintenance'
        WHERE VehicleID = NEW.VehicleID;
    END IF;
END//

DELIMITER ;
```



#### `after_maintenance_update`

Sets the vehicle back to `Available` once the maintenance is marked `Completed`.

```sql
DELIMITER //

CREATE TRIGGER after_maintenance_update
AFTER UPDATE ON maintenance
FOR EACH ROW
BEGIN
    IF NEW.MaintenanceStatus = 'Completed' THEN
        UPDATE vehicle
        SET VehicleStatus = 'Available'
        WHERE VehicleID = NEW.VehicleID;
    END IF;
END//

DELIMITER ;
```


#### `before_driver_delete`

When a driver is deleted, replaces the `DriverID` in related trips with `-1` as a dummy value.

```sql
DELIMITER //

CREATE TRIGGER before_driver_delete
BEFORE DELETE ON driver
FOR EACH ROW
BEGIN
    UPDATE trip
    SET DriverID = -1
    WHERE DriverID = OLD.DriverID;
END//

DELIMITER ;
```


#### `before_vehicle_delete`

When a vehicle is deleted, replaces the `VehicleID` in related trips with `-1` as a dummy value.

```sql
DELIMITER //

CREATE TRIGGER before_vehicle_delete
BEFORE DELETE ON vehicle
FOR EACH ROW
BEGIN
    UPDATE trip
    SET VehicleID = -1
    WHERE VehicleID = OLD.VehicleID;
END//

DELIMITER ;
```
---

### Special insertions regarding the dummy values
Dummy rows in the driver and vehicle tables to link the -1 dummy value inserted in the trips table to them.
```sql
INSERT INTO driver (DriverID, FirstName, LastName, LicenseNumber, Phone, Email, HireDate)
VALUES (-1, 'Unknown', 'Driver', 'N/A', 'N/A', 'N/A@N/A.N/A', DATE(NOW()));

INSERT INTO vehicle (VehicleID, PlateNumber, Make, Model, Year, VehicleStatus, OdometerReading)
VALUES (-1, 'UNKNOWN', 'N/A', 'N/A', 0, 'Unavailable', 0);
```
---

## Temporary Tables

### `daily_operations_summary` (Daily Operations Dashboard)

Summarizes **today’s operational activity**, including total trips, drivers, vehicles used, distances, and trip status breakdown.

```sql
CREATE TEMPORARY TABLE daily_operations_summary AS
SELECT 
    DATE(t.StartTime) AS operation_date,
    COUNT(DISTINCT t.TripID) AS total_trips,
    COUNT(DISTINCT t.DriverID) AS active_drivers,
    COUNT(DISTINCT t.VehicleID) AS vehicles_used,
    SUM(t.Distance) AS total_distance,
    AVG(t.Distance) AS avg_trip_distance,
    COUNT(CASE WHEN t.TripStatus = 'Completed' THEN 1 END) AS completed_trips,
    COUNT(CASE WHEN t.TripStatus = 'Ongoing' THEN 1 END) AS ongoing_trips,
    COUNT(CASE WHEN t.TripStatus = 'Canceled' THEN 1 END) AS canceled_trips
FROM trip t
WHERE DATE(t.StartTime) = CURDATE()
GROUP BY DATE(t.StartTime);
```

### `vehicle_cost_analysis` (Vehicle Total Cost Breakdown)

Calculates **fuel**, **maintenance**, and **violation** costs per vehicle, as well as their **total operating cost**.

```sql
CREATE TEMPORARY TABLE vehicle_cost_analysis AS
SELECT 
    v.VehicleID,
    v.PlateNumber,
    CONCAT(v.Make, ' ', v.Model, ' ', v.Year) AS vehicle_info,
    COALESCE(fuel_costs.total_fuel_cost, 0) AS total_fuel_cost,
    COALESCE(maint_costs.total_maintenance_cost, 0) AS total_maintenance_cost,
    COALESCE(viol_costs.total_violation_cost, 0) AS total_violation_cost,
    (COALESCE(fuel_costs.total_fuel_cost, 0) + 
     COALESCE(maint_costs.total_maintenance_cost, 0) + 
     COALESCE(viol_costs.total_violation_cost, 0)) AS total_operating_cost
FROM vehicle v
LEFT JOIN (
    SELECT VehicleID, SUM(Cost) AS total_fuel_cost
    FROM fuellog
    GROUP BY VehicleID
) fuel_costs ON v.VehicleID = fuel_costs.VehicleID
LEFT JOIN (
    SELECT VehicleID, SUM(Cost) AS total_maintenance_cost
    FROM maintenance
    WHERE MaintenanceStatus = 'Completed'
    GROUP BY VehicleID
) maint_costs ON v.VehicleID = maint_costs.VehicleID
LEFT JOIN (
    SELECT VehicleID, SUM(PenaltyAmount) AS total_violation_cost
    FROM violation
    GROUP BY VehicleID
) viol_costs ON v.VehicleID = viol_costs.VehicleID
WHERE v.vehicleID <> -1;
```