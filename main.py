from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime, date
import mysql.connector
from mysql.connector import Error
import json

app = FastAPI(title="Fleet Management System API")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database configuration
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "fms"
}

# Pydantic models for request/response
class DriverBase(BaseModel):
    DriverID: int
    FirstName: str
    LastName: str
    LicenseNumber: str
    Phone: str
    Email: Optional[EmailStr] = None

class VehicleBase(BaseModel):
    PlateNumber: str
    Make: str
    Model: str
    Year: Optional[int] = None
    VehicleStatus: str = "Available"
    OdometerReading: Optional[int] = None

class TripBase(BaseModel):
    DriverID: int
    VehicleID: int
    OriginLocationID: int
    DestinationLocationID: int
    Distance: float

class MaintenanceBase(BaseModel):
    VehicleID: int
    Description: Optional[str] = None
    Cost: float
    PerformedBy: Optional[str] = None

class FuelLogBase(BaseModel):
    VehicleID: int
    FuelType: Optional[str] = None
    Quantity: Optional[float] = None
    Cost: float

class ViolationBase(BaseModel):
    VehicleID: int
    Description: Optional[str] = None
    PenaltyAmount: float

class StatusUpdate(BaseModel):
    status: str

# Database connection helper
def get_db_connection():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Database connection failed: {str(e)}")

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "Fleet Management System API", "version": "1.0"}

# Dashboard endpoints
@app.get("/api/dashboard/stats")
def get_dashboard_stats():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        query = """
        SELECT 
            (SELECT COUNT(*) FROM driver WHERE DriverID > 0) as total_drivers,
            (SELECT COUNT(*) FROM vehicle WHERE VehicleStatus = 'Available' AND VehicleID > 0) as available_vehicles,
            (SELECT COUNT(*) FROM trip WHERE TripStatus = 'Ongoing') as ongoing_trips,
            (SELECT COUNT(*) FROM vehicle WHERE VehicleStatus = 'In Maintenance' AND VehicleID > 0) as vehicles_in_maintenance
        """
        cursor.execute(query)
        result = cursor.fetchone()
        return result
    finally:
        cursor.close()
        conn.close()

# Driver endpoints
@app.get("/api/drivers")
def get_drivers():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT * FROM driver WHERE DriverID > 0 ORDER BY DriverID")
        drivers = cursor.fetchall()
        return drivers
    finally:
        cursor.close()
        conn.close()

@app.post("/api/drivers")
def create_driver(driver: DriverBase):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        query = """
        INSERT INTO driver (DriverID, FirstName, LastName, LicenseNumber, Phone, Email)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        values = (driver.DriverID, driver.FirstName, driver.LastName, driver.LicenseNumber, 
                 driver.Phone, driver.Email)
        cursor.execute(query, values)
        conn.commit()
        
        return {"message": "Driver created successfully", "id": cursor.lastrowid}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.delete("/api/drivers/{driver_id}")
def delete_driver(driver_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute("DELETE FROM driver WHERE DriverID = %s", (driver_id,))
        conn.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Driver not found")
            
        return {"message": "Driver deleted successfully"}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Get single driver endpoint
@app.get("/api/drivers/{driver_id}")
async def get_driver(driver_id: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT DriverID, FirstName, LastName, LicenseNumber, 
                   Phone, Email, HireDate
            FROM driver
            WHERE DriverID = %s
        """, (driver_id,))
        
        driver = cursor.fetchone()
        
        if not driver:
            raise HTTPException(status_code=404, detail="Driver not found")
        
        return {
            "DriverID": driver[0],
            "FirstName": driver[1],
            "LastName": driver[2],
            "LicenseNumber": driver[3],
            "Phone": driver[4],
            "Email": driver[5],
            "HireDate": driver[6].strftime("%Y-%m-%d") if driver[6] else None
        }
        
    except mysql.connector.Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Update driver endpoint
@app.put("/api/drivers/{driver_id}")
async def update_driver(driver_id: int, driver_data: dict):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # First check if driver exists
        cursor.execute("SELECT DriverID FROM driver WHERE DriverID = %s", (driver_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Driver not found")
        
        # Update driver information
        cursor.execute("""
            UPDATE driver 
            SET FirstName = %s, 
                LastName = %s, 
                Phone = %s, 
                Email = %s,
                HireDate = %s
            WHERE DriverID = %s
        """, (
            driver_data.get("FirstName"),
            driver_data.get("LastName"),
            driver_data.get("Phone"),
            driver_data.get("Email"),
            driver_data.get("HireDate"),
            driver_id
        ))
        
        conn.commit()
        
        return {"message": "Driver updated successfully", "driver_id": driver_id}
        
    except mysql.connector.Error as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Vehicle endpoints
@app.get("/api/vehicles")
def get_vehicles():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT * FROM vehicle WHERE VehicleID > 0 ORDER BY VehicleID")
        vehicles = cursor.fetchall()
        return vehicles
    finally:
        cursor.close()
        conn.close()

@app.get("/api/vehicles/available")
def get_available_vehicles():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT * FROM vehicle WHERE VehicleStatus = 'Available' AND VehicleID > 0")
        vehicles = cursor.fetchall()
        return vehicles
    finally:
        cursor.close()
        conn.close()

@app.post("/api/vehicles")
def create_vehicle(vehicle: VehicleBase):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        query = """
        INSERT INTO vehicle (PlateNumber, Make, Model, Year, VehicleStatus, OdometerReading)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        values = (vehicle.PlateNumber, vehicle.Make, vehicle.Model, 
                 vehicle.Year, vehicle.VehicleStatus, vehicle.OdometerReading)
        cursor.execute(query, values)
        conn.commit()
        
        return {"message": "Vehicle created successfully", "id": cursor.lastrowid}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.put("/api/vehicles/{vehicle_id}/status")
def update_vehicle_status(vehicle_id: int, status_update: StatusUpdate):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            "UPDATE vehicle SET VehicleStatus = %s WHERE VehicleID = %s",
            (status_update.status, vehicle_id)
        )
        conn.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Vehicle not found")
            
        return {"message": "Vehicle status updated successfully"}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.delete("/api/vehicles/{vehicle_id}")
def delete_vehicle(vehicle_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute("DELETE FROM vehicle WHERE VehicleID = %s", (vehicle_id,))
        conn.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Vehicle not found")
            
        return {"message": "Vehicle deleted successfully"}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Location endpoints
@app.get("/api/locations")
def get_locations():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT * FROM location ORDER BY LocationID")
        locations = cursor.fetchall()
        return locations
    finally:
        cursor.close()
        conn.close()

# Trip endpoints
@app.get("/api/trips")
def get_trips():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        query = """
                select 
                    TripID,
                    DriverName,
                    Vehicle,
                    VehiclePlate AS Plate,
                    OriginLocation AS Origin,
                    EndLocation AS Destination,
                    Distance,
                    DATE_FORMAT(StartTime, '%Y-%m-%d %H:%i') AS StartTime,
                    CASE 
                        WHEN EndTime = '9999-12-31 23:59:59' THEN '-'
                        ELSE DATE_FORMAT(EndTime, '%Y-%m-%d %H:%i')
                    END AS EndTime,
                    TripStatus
                from all_trips
                order by TripID desc;
                """
        cursor.execute(query)
        trips = cursor.fetchall()
        return trips
    finally:
        cursor.close()
        conn.close()

@app.post("/api/trips")
def create_trip(trip: TripBase):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        query = """
        INSERT INTO trip (DriverID, VehicleID, OriginLocationID, DestinationLocationID, Distance)
        VALUES (%s, %s, %s, %s, %s)
        """
        values = (trip.DriverID, trip.VehicleID, trip.OriginLocationID, 
                 trip.DestinationLocationID, trip.Distance)
        cursor.execute(query, values)
        conn.commit()
        
        return {"message": "Trip created successfully", "id": cursor.lastrowid}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.put("/api/trips/{trip_id}/complete")
def complete_trip(trip_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            "UPDATE trip SET TripStatus = 'Completed' WHERE TripID = %s",
            (trip_id,)
        )
        conn.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Trip not found")
            
        return {"message": "Trip completed successfully"}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.put("/api/trips/{trip_id}/cancel")
def cancel_trip(trip_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            "UPDATE trip SET TripStatus = 'Canceled' WHERE TripID = %s",
            (trip_id,)
        )
        conn.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Trip not found")
            
        return {"message": "Trip cancelled successfully"}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Maintenance endpoints
@app.get("/api/maintenance")
def get_maintenance():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        query = """
        SELECT 
            m.MaintenanceID,
            m.VehicleID,
            m.Date,
            m.Description,
            m.Cost,
            m.PerformedBy,
            m.MaintenanceStatus,
            CONCAT(v.PlateNumber, ' - ', v.Make, ' ', v.Model) AS vehicle_info
        FROM maintenance m
            JOIN vehicle v ON m.VehicleID = v.VehicleID
        ORDER BY m.Date DESC
        """
        cursor.execute(query)
        maintenance = cursor.fetchall()
        return maintenance
    finally:
        cursor.close()
        conn.close()

@app.post("/api/maintenance")
def create_maintenance(maintenance: MaintenanceBase):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        query = """
        INSERT INTO maintenance (VehicleID, Description, Cost, PerformedBy)
        VALUES (%s, %s, %s, %s)
        """
        values = (maintenance.VehicleID, maintenance.Description, 
                 maintenance.Cost, maintenance.PerformedBy)
        cursor.execute(query, values)
        conn.commit()
        
        return {"message": "Maintenance record created successfully", "id": cursor.lastrowid}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

@app.put("/api/maintenance/{maintenance_id}/complete")
def complete_maintenance(maintenance_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            "UPDATE maintenance SET MaintenanceStatus = 'Completed' WHERE MaintenanceID = %s",
            (maintenance_id,)
        )
        conn.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Maintenance record not found")
            
        return {"message": "Maintenance completed successfully"}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Fuel Log endpoints
@app.get("/api/fuel-logs")
def get_fuel_logs():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        query = """
        SELECT 
            f.FuelLogID,
            f.VehicleID,
            f.Date,
            f.FuelType,
            f.Quantity,
            f.Cost,
            CONCAT(v.PlateNumber, ' - ', v.Make, ' ', v.Model) AS vehicle_info
        FROM fuellog f
            JOIN vehicle v ON f.VehicleID = v.VehicleID
        ORDER BY f.Date DESC
        """
        cursor.execute(query)
        fuel_logs = cursor.fetchall()
        return fuel_logs
    finally:
        cursor.close()
        conn.close()

@app.post("/api/fuel-logs")
def create_fuel_log(fuel_log: FuelLogBase):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        query = """
        INSERT INTO fuellog (VehicleID, FuelType, Quantity, Cost)
        VALUES (%s, %s, %s, %s)
        """
        values = (fuel_log.VehicleID, fuel_log.FuelType, 
                 fuel_log.Quantity, fuel_log.Cost)
        cursor.execute(query, values)
        conn.commit()
        
        return {"message": "Fuel log created successfully", "id": cursor.lastrowid}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Violation endpoints
@app.get("/api/violations")
def get_violations():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        query = """
        SELECT 
            v.ViolationID,
            v.VehicleID,
            v.Date,
            v.Description,
            v.PenaltyAmount,
            CONCAT(veh.PlateNumber, ' - ', veh.Make, ' ', veh.Model) AS vehicle_info
        FROM violation v
            JOIN vehicle veh ON v.VehicleID = veh.VehicleID
        ORDER BY v.Date DESC
        """
        cursor.execute(query)
        violations = cursor.fetchall()
        return violations
    finally:
        cursor.close()
        conn.close()

@app.post("/api/violations")
def create_violation(violation: ViolationBase):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        query = """
        INSERT INTO violation (VehicleID, Description, PenaltyAmount)
        VALUES (%s, %s, %s)
        """
        values = (violation.VehicleID, violation.Description, violation.PenaltyAmount)
        cursor.execute(query, values)
        conn.commit()
        
        return {"message": "Violation created successfully", "id": cursor.lastrowid}
    except Error as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cursor.close()
        conn.close()

# Advanced Query endpoints
@app.get("/api/queries/ongoing-trips")
def get_ongoing_trips():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT * FROM ongoing_trips;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/available-vehicles")
def get_available_vehicles_view():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT * FROM available_vehicles;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/violations-details")
def get_violations_details():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT * FROM violations_details;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/vehicle-cost-analysis")
def get_vehicle_cost_analysis():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    CREATE TEMPORARY TABLE IF NOT EXISTS vehicle_cost_analysis AS
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
    WHERE v.VehicleID <> -1;
    """
    
    try:
        cursor.execute(sql_query)
        cursor.execute("SELECT * FROM vehicle_cost_analysis")
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/daily-operations")
def get_daily_operations():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    CREATE TEMPORARY TABLE IF NOT EXISTS daily_operations_summary AS
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
    """
    
    try:
        cursor.execute(sql_query)
        cursor.execute("SELECT * FROM daily_operations_summary")
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/driver-trips/{driver_id}")
def get_driver_trips_procedure(driver_id: int):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = f"""
    CALL GetDriverTrips({driver_id});
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/vehicle-maintenance/{vehicle_id}")
def get_vehicle_maintenance_procedure(vehicle_id: int):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = f"""
    CALL GetVehicleMaintenanceHistory({vehicle_id});
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/drivers-performance")
def get_drivers_performance():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH driver_trips_completed_count AS (
        SELECT
            DriverID,
            COUNT(DriverID) AS trips_completed
        FROM
            all_trips
        WHERE
            TripStatus = 'Completed'
        GROUP BY
            DriverID, DriverName
    ),
    completion_rates AS (
        SELECT
            all_t.DriverID,
            all_t.DriverName,
            ROUND((completed_t.trips_completed / COUNT(all_t.DriverID)) * 100, 2) AS trip_completion_rate
        FROM
            all_trips all_t JOIN driver_trips_completed_count completed_t ON
            all_t.DriverID = completed_t.DriverID
        GROUP BY
            DriverID, DriverName
    )
    SELECT
        *,
        CASE
            WHEN trip_completion_rate >= 90 THEN 'TOP'
            WHEN trip_completion_rate >= 80 THEN 'MED'
            ELSE 'LOW'
        END AS Tier
    FROM
        completion_rates
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()
        
@app.get("/api/queries/top-drivers-manufacturer")
def get_top_drivers_manufacturer():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    With manufacturer_driver_dist AS (
        SELECT
            SUBSTRING_INDEX(Vehicle, ',', 1) AS manufacturer,
            DriverID,
            DriverName,
            ROUND(SUM(Distance), 2) AS covered_distance,
            ROW_NUMBER() OVER(PARTITION BY SUBSTRING_INDEX(Vehicle, ',', 1) ORDER BY SUM(Distance) DESC) AS row_num
        FROM
            all_trips
        GROUP BY SUBSTRING_INDEX(Vehicle, ',', 1), DriverID, DriverName
    )
    SELECT
        *
    FROM
        manufacturer_driver_dist
    WHERE
        row_num <= 3;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/most-driven-vehicles')
def get_most_driven_vehicles():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT
        VehicleID,
        Vehicle,
        ROUND(SUM(Distance), 2) AS total_distance,
        DENSE_RANK() OVER(ORDER BY SUM(Distance) DESC) AS most_driven_ranking
    FROM
        all_trips
    GROUP BY
        VehicleID, Vehicle;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query":sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/maintenance-expenses')
def get_maintenance_expenses():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT
        YEAR(Date) AS year,
        MONTH(Date) AS month,
        DATE(Date) AS day,
        SUM(Cost) AS total_cost
    FROM
        all_maintenances
    GROUP BY YEAR(Date), MONTH(Date), DATE(Date) WITH ROLLUP;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/driver-performance-percentiles')
def get_driver_performance_percentiles():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH driver_trips_completed_count AS (
        SELECT
            d.DriverID,
            CONCAT(d.FirstName, ' ', d.LastName) AS driver_name,
            COUNT(all_t.DriverID) AS trips_completed
        FROM
            all_trips all_t JOIN driver d 
            ON all_t.DriverID = d.DriverID
        WHERE
            all_t.TripStatus = 'Completed' AND
            d.DriverID <> -1
        GROUP BY
            DriverID, driver_name
    )
    SELECT
        *,
        CONCAT(ROUND(CUME_DIST() OVER(ORDER BY trips_completed) * 100, 2), '%') AS outperforms_or_equal_to,
        CONCAT(ROUND(PERCENT_RANK() OVER(ORDER BY trips_completed) * 100, 2), '%') AS outperforms
    FROM
        driver_trips_completed_count;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/loyal-maintenance-providers')
def get_loyal_maintenance_providers():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH vehicle_depending_maintenancee_provider AS (
        SELECT
            MaintenanceID,
            VehicleID,
            Date,
            PerformedBy AS maintenance_provider,
            ROW_NUMBER() OVER(PARTITION BY VehicleID ORDER BY Date DESC) AS row_num,
            COUNT(1) OVER(PARTITION BY VehicleID) AS records_count
        FROM
            maintenance
    ),
    filtered AS (
        SELECT
            VehicleID,
            maintenance_provider
        FROM
            vehicle_depending_maintenancee_provider
        WHERE
            row_num <= 3 AND records_count >= 3
    )
    SELECT
        f.VehicleID,
        v.PlateNumber AS VehiclePlate,
        CONCAT(v.Make, ', ', v.Model) AS Vehicle,
        f.maintenance_provider
    FROM
        filtered f JOIN vehicle v
        ON f.VehicleID = v.VehicleID
    GROUP BY
        1, 2, 3, 4
    HAVING COUNT(1) = 3;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/safe-drivers-unsafe-vehicles')
def get_safe_drivers_unsafe_vehicles():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH top_unsafe_cars AS (
        SELECT
            VehicleID,
            COUNT(VehicleID) AS violation_count
        FROM
            violation
        GROUP BY
            VehicleID
        ORDER BY
            violation_count DESC
        LIMIT 5
    ),
    not_included_drivers AS (
        SELECT
            DISTINCT(DriverID)
        FROM
            violations_details vd JOIN top_unsafe_cars tuc
            ON vd.VehicleID = tuc.VehicleID
    ),
    all_drivers_drove_unsafe_cars AS (
        SELECT
            DriverID,
            COUNT(DriverID) AS number_of_times_drove_unsafe_car
        FROM
            trip
        WHERE
            VehicleID IN (SELECT VehicleID FROM top_unsafe_cars)
        GROUP BY
            DriverID
        HAVING
            number_of_times_drove_unsafe_car >= 3
    )
    SELECT
        ad.DriverID,
        CONCAT(d.FirstName, ' ', d.LastName) AS dirver_name,
        d.LicenseNumber,
        ad.number_of_times_drove_unsafe_car,
        0 AS number_of_violations
    FROM
        all_drivers_drove_unsafe_cars ad JOIN driver d
        ON ad.DriverID = d.DriverID
    WHERE
        ad.DriverID NOT IN (SELECT DriverID FROM not_included_drivers);
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/vehicle-distance-milestones')
def get_vehicle_distance_milestones():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH vehicle_distance AS (
        SELECT
            VehicleID,
            Distance,
            ROUND(SUM(Distance) OVER(PARTITION BY VehicleID ORDER BY Distance), 2) AS distance_running_total,
            ROUND(SUM(Distance) OVER(PARTITION BY VehicleID), 2) AS total_distance,
            DATE(StartTime) AS date
        FROM
            trip
        WHERE
            TripStatus = 'Completed'
    )
    SELECT
        VehicleID,
        Distance,
        distance_running_total,
        CASE
            WHEN distance_running_total >= (total_distance / 2) THEN 'YES'
            ELSE 'NO'
        END AS above_50_percent,
        date
    FROM
        vehicle_distance;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/route-efficiency-rankings')
def get_route_efficiency_rankings():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH drivers_routes AS (
        SELECT
            CONCAT(OriginLocation, ' -> ', EndLocation) AS route,
            DriverID,
            DriverName,
            COUNT(*) AS trips_count,
            ROUND(AVG(CAST(REPLACE(Distance, ' KM', '') AS DECIMAL(10,2))), 2) AS avg_distance_km,
            ROUND(AVG(TIMESTAMPDIFF(MINUTE, StartTime, EndTime)), 2) AS avg_minutes,
            ROUND(AVG(
                CAST(REPLACE(Distance, ' KM', '') AS DECIMAL(10,2)) / 
                (TIMESTAMPDIFF(MINUTE, StartTime, EndTime) / 60.0)
            ), 2) AS avg_speed_kmh
        FROM
            all_trips
        WHERE
            TripStatus = 'Completed'
            AND TIMESTAMPDIFF(MINUTE, StartTime, EndTime) > 0
        GROUP BY
            OriginLocation, EndLocation, DriverID, DriverName
    )
    SELECT
        route,
        DriverID,
        DriverName,
        trips_count,
        avg_distance_km,
        avg_minutes,
        avg_speed_kmh,
        DENSE_RANK() OVER(PARTITION BY route ORDER BY avg_speed_kmh DESC) AS efficiency_rank
    FROM
        drivers_routes
    ORDER BY
        route, efficiency_rank;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/vehicle-trip-evolution')
def get_vehicle_trip_evolution():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH vehicle_trips AS (
        SELECT
            VehicleID,
            Vehicle,
            VehiclePlate,
            CAST(REPLACE(Distance, ' KM', '') AS DECIMAL(10,2)) AS distance_km,
            StartTime,
            FIRST_VALUE(CAST(REPLACE(Distance, ' KM', '') AS DECIMAL(10,2))) 
                OVER(PARTITION BY VehicleID ORDER BY StartTime) AS first_trip_distance,
            LAST_VALUE(CAST(REPLACE(Distance, ' KM', '') AS DECIMAL(10,2))) 
                OVER(PARTITION BY VehicleID ORDER BY StartTime 
                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_trip_distance,
            FIRST_VALUE(StartTime) 
                OVER(PARTITION BY VehicleID ORDER BY StartTime) AS first_trip_date,
            LAST_VALUE(StartTime) 
                OVER(PARTITION BY VehicleID ORDER BY StartTime 
                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_trip_date,
            ROW_NUMBER() OVER(PARTITION BY VehicleID ORDER BY StartTime) AS rn
        FROM
            all_trips
        WHERE
            TripStatus = 'Completed'
    )
    SELECT DISTINCT
        VehicleID,
        Vehicle,
        VehiclePlate,
        first_trip_distance,
        last_trip_distance,
        ROUND(last_trip_distance - first_trip_distance, 2) AS distance_change,
        ROUND(((last_trip_distance - first_trip_distance) / first_trip_distance) * 100, 2) AS percent_change,
        DATE(first_trip_date) AS first_trip_date,
        DATE(last_trip_date) AS last_trip_date,
        DATEDIFF(last_trip_date, first_trip_date) AS days_between_trips
    FROM
        vehicle_trips
    ORDER BY
        VehicleID;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/maintenance-cost-analysis')
def get_maintenance_cost_analysis():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT
        PerformedBy AS maintenance_provider,
        SUBSTRING_INDEX(Vehicle, ',', 1) AS make,
        AVG(cost) AS avg_maintenance_cost
    FROM
        all_maintenances
    GROUP BY PerformedBy, SUBSTRING_INDEX(Vehicle, ',', 1) WITH ROLLUP;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/driver-tenure-analysis')
def get_driver_tenure_analysis():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT
        DriverID,
        CONCAT(FirstName, ' ', LastName) AS DriverName,
        HireDate,
        DATEDIFF(CURDATE(), HireDate) AS days_of_service,
        CASE
            WHEN DATEDIFF(CURDATE(), HireDate) >= 1825 THEN '5+ Years'
            WHEN DATEDIFF(CURDATE(), HireDate) >= 365 THEN '1+ Year'
            ELSE 'Less than 1 Year'
        END AS tenure_category
    FROM
        driver
    WHERE
        DriverID <> -1
    ORDER BY
        days_of_service DESC;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/driver-violation-rankings')
def get_driver_violation_rankings():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    SELECT
        d.DriverID,
        CONCAT(d.FirstName, ' ', d.lastName) AS DriverName,
        COUNT(vd.DriverID) AS number_of_violations,
        DENSE_RANK() OVER(ORDER BY COUNT(vd.DriverID) DESC) AS violation_rank
    FROM
        driver d LEFT JOIN violations_details vd 
        ON vd.DriverID = d.DriverID
    WHERE
        d.DriverID <> -1
    GROUP BY DriverID, DriverName;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get('/api/queries/fuel-efficiency-analysis')
def get_fuel_efficiency_analysis():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    WITH fuellog_advanced AS (
        SELECT
            *,
            LEAD(Date) OVER(PARTITION BY VehicleID ORDER BY Date) AS next_refuel
        FROM
            fuellog
    ),
    fuel_distance AS (
        SELECT
            v.VehicleID,
            CONCAT(v.Make, ', ', v.Model) AS vehicle,
            CONCAT(DATE(fl.Date), ' - ', DATE(fl.next_refuel)) AS test_period,
            fl.Quantity AS fuel_quantity,
            fl.FuelType,
            ROUND(SUM(t.Distance), 2) AS total_distance
        FROM
            vehicle v
            JOIN
            fuellog_advanced fl ON v.VehicleID = fl.VehicleID
            JOIN
            trip t ON fl.VehicleID = t.VehicleID
        WHERE
            t.StartTime >= fl.Date AND t.StartTime < fl.next_refuel
        GROUP BY
            1, 2, 3, 4, 5
    )   
    SELECT
        VehicleID,
        Vehicle,
        test_period AS fuel_period,
        fuel_quantity,
        total_distance,
        CASE 
            WHEN FuelType = 'Electric' THEN CONCAT(ROUND(fuel_quantity / total_distance, 2), ' ', 'KW/KM')
            ELSE CONCAT(ROUND(fuel_quantity / total_distance, 2), ' ', 'L/KM')
        END AS usage_rate
    FROM
        fuel_distance;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/drivers-never-violated")
def get_drivers_never_violated():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    -- Drivers who have driven but never got violations (using EXCEPT)
    SELECT DISTINCT d.DriverID, CONCAT(d.FirstName, ' ', d.LastName) as DriverName
    FROM driver d
    JOIN trip t ON d.DriverID = t.DriverID
    WHERE d.DriverID > 0
    
    EXCEPT
    
    SELECT DISTINCT d.DriverID, CONCAT(d.FirstName, ' ', d.LastName) as DriverName
    FROM driver d
    JOIN trip t ON d.DriverID = t.DriverID
    JOIN violation v ON t.VehicleID = v.VehicleID
    WHERE v.Date BETWEEN t.StartTime AND t.EndTime
    AND d.DriverID > 0;
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/vehicles-no-maintenance")
def get_vehicles_no_maintenance():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    -- Vehicles that have never been maintained (using NOT EXISTS)
    SELECT v.VehicleID, v.PlateNumber, CONCAT(v.Make, ' ', v.Model) as Vehicle
    FROM vehicle v
    WHERE v.VehicleID > 0
    AND NOT EXISTS (
        SELECT 1 
        FROM maintenance m 
        WHERE m.VehicleID = v.VehicleID
    );
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

@app.get("/api/queries/drivers-above-average-distance")
def get_drivers_above_average():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    sql_query = """
    -- Drivers who have driven more than ALL average distances per driver
    SELECT d.DriverID, CONCAT(d.FirstName, ' ', d.LastName) as DriverName, 
           SUM(t.Distance) as TotalDistance
    FROM driver d
    JOIN trip t ON d.DriverID = t.DriverID
    WHERE d.DriverID > 0
    GROUP BY d.DriverID, d.FirstName, d.LastName
    HAVING SUM(t.Distance) > ALL (
        SELECT AVG(Distance) 
        FROM trip 
        GROUP BY DriverID
    );
    """
    
    try:
        cursor.execute(sql_query)
        data = cursor.fetchall()
        return {"sql_query": sql_query, "data": data}
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)