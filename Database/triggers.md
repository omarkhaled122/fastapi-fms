# Triggers

## `before_trip_insert`

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


## `after_trip_insert`

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

## `before_trip_update`

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

## `after_trip_update`

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

## `after_maintenance_insert`

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

## `after_maintenance_update`

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

## `before_driver_delete`

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

## `before_vehicle_delete`

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