# Tables Creation

## Driver Table
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
```

## Vehicle Table

```sql
CREATE TABLE vehicle (
    VehicleID INTEGER PRIMARY KEY,
    PlateNumber VARCHAR(20) UNIQUE NOT NULL,
    Make VARCHAR(20) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    Year INTEGER,
    VehicleStatus ENUM('Available', 'In Maintenance', 'In Trip', 'Unavailable') NOT NULL DEFAULT 'Available',
    OdometerReading INTEGER
);
```

## Location Table

```sql
CREATE TABLE location (
    LocationID INTEGER PRIMARY KEY,
    Address VARCHAR(50),
    City VARCHAR(20),
    Country VARCHAR(20)
);
```

## Trip Table

```sql
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
```

## Fuel Log Table

```sql
CREATE TABLE fuellog (
    FuelLogID INTEGER AUTO_INCREMENT PRIMARY KEY,
    VehicleID INTEGER NOT NULL,
    Date DATE DEFAULT DATE((CURRENT_TIMESTAMP)),
    FuelType ENUM('Gasoline', 'Diesel', 'Electric'),
    Quantity FLOAT,
    Cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID) ON DELETE CASCADE
);
```

## Maintenance Table

```sql
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
```

## Violation Table

```sql
CREATE TABLE violation (
    ViolationID INTEGER AUTO_INCREMENT PRIMARY KEY,
    VehicleID INTEGER NOT NULL,
    Date DATETIME DEFAULT (CURRENT_TIMESTAMP),
    Description TEXT,
    PenaltyAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID) ON DELETE CASCADE
);
```
