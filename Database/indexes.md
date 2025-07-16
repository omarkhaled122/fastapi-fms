
# Indexes

## Trip Table Indexes

### trip_driver_idx
Created on **DriverID** in the **trip** table to enable efficient searching of trips by driver ID.

```sql
CREATE INDEX trip_driver_idx
ON trip(DriverID);
```

### trip\_vehicle\_idx

Created on **VehicleID** in the **trip** table to enable efficient searching of trips by vehicle ID.

```sql
CREATE INDEX trip_vehicle_idx
ON trip(VehicleID);
```

### trip\_day\_idx

A functional index created on **StartTime** in the **trip** table to enable efficient searching of trips by day using the **DAY()** function.

```sql
CREATE INDEX trip_day_idx
ON trip((DAY(StartTime)));
```

---

## Fuel Log Table Indexes

### fuellog\_vehicle\_idx

Created on **VehicleID** in the **fuellog** table to enable efficient searching of fuel logs by vehicle ID.

```sql
CREATE INDEX fuellog_vehicle_idx
ON fuellog(VehicleID);
```

---

## Maintenance Table Indexes

### maintenance\_vehicle\_idx

Created on **VehicleID** in the **maintenance** table to enable efficient searching of maintenance logs by vehicle ID.

```sql
CREATE INDEX maintenance_vehicle_idx
ON maintenance(VehicleID);
```

---

## Violation Table Indexes

### violation\_vehicle\_idx

Created on **VehicleID** in the **violation** table to enable efficient searching of violations by vehicle ID.

```sql
CREATE INDEX violation_vehicle_idx
ON violation(VehicleID);
```

### violation\_day\_idx

A functional index created on **Date** in the **violation** table to enable efficient searching of violations by day using the **DAY()** function.

```sql
CREATE INDEX violation_day_idx
ON violation((DAY(Date)));
```
