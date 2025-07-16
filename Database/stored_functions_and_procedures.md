# Stored Functions

## `get_vehicle_status(vehicle_id INT)`

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

## `get_trip_status(trip_id INT)`

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

## `get_maintenance_status(maintenance_id INT)`

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
## `distance_level(distance FLOAT)`

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
---

# Stored Procedures

## `GetTripDistanceLevel(trip_id INT, OUT trip_distance_level VARCHAR(10))`

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

## `GetDriverTrips(driver_id INT)`

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

## `GetVehicleMaintenanceHistory(vehicle_id INT)`

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
