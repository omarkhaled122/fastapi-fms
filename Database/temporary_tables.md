# Temporary Tables

## `daily_operations_summary` (Daily Operations Dashboard)

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

## `vehicle_cost_analysis` (Vehicle Total Cost Breakdown)

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