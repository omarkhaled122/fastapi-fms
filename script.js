// API Base URL
const API_URL = 'http://localhost:8000/api';

// Current query SQL storage
let currentQuerySQL = '';

// Show section function
function showSection(sectionName) {
    // Hide all sections
    document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Remove active class from all nav buttons
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected section
    document.getElementById(sectionName).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
    
    // Load data for the section
    loadSectionData(sectionName);
}

// Load data based on section
async function loadSectionData(section) {
    switch(section) {
        case 'dashboard':
            loadDashboard();
            break;
        case 'drivers':
            loadDrivers();
            break;
        case 'vehicles':
            loadVehicles();
            break;
        case 'trips':
            loadTrips();
            break;
        case 'maintenance':
            loadMaintenance();
            break;
        case 'fuel':
            loadFuelLogs();
            break;
        case 'violations':
            loadViolations();
            break;
    }
}

// Dashboard functions
async function loadDashboard() {
    try {
        const response = await fetch(`${API_URL}/dashboard/stats`);
        const data = await response.json();
        
        document.getElementById('total-drivers').textContent = data.total_drivers;
        document.getElementById('available-vehicles').textContent = data.available_vehicles;
        document.getElementById('ongoing-trips').textContent = data.ongoing_trips;
        document.getElementById('maintenance-count').textContent = data.vehicles_in_maintenance;
    } catch (error) {
        console.error('Error loading dashboard:', error);
    }
}

// Drivers functions
async function loadDrivers() {
    try {
        const response = await fetch(`${API_URL}/drivers`);
        const drivers = await response.json();
        
        const tbody = document.querySelector('#drivers-table tbody');
        tbody.innerHTML = '';
        
        drivers.forEach(driver => {
            const row = `
                <tr>
                    <td>${driver.DriverID}</td>
                    <td>${driver.FirstName} ${driver.LastName}</td>
                    <td>${driver.LicenseNumber}</td>
                    <td>${driver.Phone}</td>
                    <td>${driver.Email || '-'}</td>
                    <td>${driver.HireDate}</td>
                    <td>
                        <button class="btn btn-danger action-btn" onclick="deleteDriver(${driver.DriverID})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading drivers:', error);
    }
}

function showAddDriverForm() {
    document.getElementById('add-driver-form').style.display = 'block';
}

function hideAddDriverForm() {
    document.getElementById('add-driver-form').style.display = 'none';
    document.querySelector('#add-driver-form form').reset();
}

async function addDriver(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    const driverData = {
        DriverID: formData.get('driverId'),
        FirstName: formData.get('firstName'),
        LastName: formData.get('lastName'),
        LicenseNumber: formData.get('licenseNumber'),
        Phone: formData.get('phone'),
        Email: formData.get('email') || null
    };
    
    try {
        const response = await fetch(`${API_URL}/drivers`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(driverData)
        });
        
        if (response.ok) {
            hideAddDriverForm();
            loadDrivers();
            alert('Driver added successfully!');
        } else {
            const error = await response.json();
            alert('Error adding driver: ' + error.detail);
        }
    } catch (error) {
        console.error('Error adding driver:', error);
        alert('Error adding driver');
    }
}

async function deleteDriver(driverId) {
    if (!confirm('Are you sure you want to delete this driver?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/drivers/${driverId}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            loadDrivers();
            alert('Driver deleted successfully!');
        } else {
            const error = await response.json();
            alert('Error deleting driver: ' + error.detail);
        }
    } catch (error) {
        console.error('Error deleting driver:', error);
        alert('Error deleting driver');
    }
}

// Vehicles functions
async function loadVehicles() {
    try {
        const response = await fetch(`${API_URL}/vehicles`);
        const vehicles = await response.json();
        
        const tbody = document.querySelector('#vehicles-table tbody');
        tbody.innerHTML = '';
        
        vehicles.forEach(vehicle => {
            const row = `
                <tr>
                    <td>${vehicle.VehicleID}</td>
                    <td>${vehicle.PlateNumber}</td>
                    <td>${vehicle.Make}</td>
                    <td>${vehicle.Model}</td>
                    <td>${vehicle.Year || '-'}</td>
                    <td>
                        <span class="status-${vehicle.VehicleStatus.toLowerCase().replace(' ', '-')}">${vehicle.VehicleStatus}</span>
                    </td>
                    <td>${vehicle.OdometerReading || '-'}</td>
                    <td>
                        <button class="btn btn-warning action-btn" onclick="updateVehicleStatus(${vehicle.VehicleID})">Update Status</button>
                        <button class="btn btn-danger action-btn" onclick="deleteVehicle(${vehicle.VehicleID})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading vehicles:', error);
    }
}

function showAddVehicleForm() {
    document.getElementById('add-vehicle-form').style.display = 'block';
}

function hideAddVehicleForm() {
    document.getElementById('add-vehicle-form').style.display = 'none';
    document.querySelector('#add-vehicle-form form').reset();
}

async function addVehicle(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    const vehicleData = {
        PlateNumber: formData.get('plateNumber'),
        Make: formData.get('make'),
        Model: formData.get('model'),
        Year: formData.get('year') ? parseInt(formData.get('year')) : null,
        VehicleStatus: formData.get('status'),
        OdometerReading: formData.get('odometerReading') ? parseInt(formData.get('odometerReading')) : null
    };
    
    try {
        const response = await fetch(`${API_URL}/vehicles`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(vehicleData)
        });
        
        if (response.ok) {
            hideAddVehicleForm();
            loadVehicles();
            alert('Vehicle added successfully!');
        } else {
            const error = await response.json();
            alert('Error adding vehicle: ' + error.detail);
        }
    } catch (error) {
        console.error('Error adding vehicle:', error);
        alert('Error adding vehicle');
    }
}

async function updateVehicleStatus(vehicleId) {
    const newStatus = prompt('Enter new status (Available, In Maintenance, In Trip, Unavailable):');
    if (!newStatus) return;
    
    try {
        const response = await fetch(`${API_URL}/vehicles/${vehicleId}/status`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ status: newStatus })
        });
        
        if (response.ok) {
            loadVehicles();
            alert('Vehicle status updated successfully!');
        } else {
            const error = await response.json();
            alert('Error updating vehicle status: ' + error.detail);
        }
    } catch (error) {
        console.error('Error updating vehicle status:', error);
        alert('Error updating vehicle status');
    }
}

async function deleteVehicle(vehicleId) {
    if (!confirm('Are you sure you want to delete this vehicle?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/vehicles/${vehicleId}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            loadVehicles();
            alert('Vehicle deleted successfully!');
        } else {
            const error = await response.json();
            alert('Error deleting vehicle: ' + error.detail);
        }
    } catch (error) {
        console.error('Error deleting vehicle:', error);
        alert('Error deleting vehicle');
    }
}

// Trips functions
async function loadTrips() {
    try {
        const response = await fetch(`${API_URL}/trips`);
        const trips = await response.json();
        
        const tbody = document.querySelector('#trips-table tbody');
        tbody.innerHTML = '';
        
        trips.forEach(trip => {
            const row = `
                <tr>
                    <td>${trip.TripID}</td>
                    <td>${trip.DriverName}</td>
                    <td>${trip.Vehicle}</td>
                    <td>${trip.Plate}</td>
                    <td>${trip.Origin}</td>
                    <td>${trip.Destination}</td>
                    <td>${trip.Distance} km</td>
                    <td>${trip.StartTime}</td>
                    <td>${trip.EndTime}</td>
                    <td>
                        <span class="status-${trip.TripStatus.toLowerCase()}">${trip.TripStatus}</span>
                    </td>
                    <td>
                        ${trip.TripStatus === 'Ongoing' ? 
                            `<button class="btn btn-success action-btn" onclick="completeTrip(${trip.TripID})">Complete</button>
                             <button class="btn btn-danger action-btn" onclick="cancelTrip(${trip.TripID})">Cancel</button>` 
                            : '-'}
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading trips:', error);
    }
}

async function showAddTripForm() {
    document.getElementById('add-trip-form').style.display = 'block';
    
    // Load drivers
    const driversResponse = await fetch(`${API_URL}/drivers`);
    const drivers = await driversResponse.json();
    const driverSelect = document.getElementById('trip-driver-select');
    driverSelect.innerHTML = '<option value="">Select Driver</option>';
    drivers.forEach(driver => {
        driverSelect.innerHTML += `<option value="${driver.DriverID}">${driver.FirstName} ${driver.LastName}</option>`;
    });
    
    // Load available vehicles
    const vehiclesResponse = await fetch(`${API_URL}/vehicles/available`);
    const vehicles = await vehiclesResponse.json();
    const vehicleSelect = document.getElementById('trip-vehicle-select');
    vehicleSelect.innerHTML = '<option value="">Select Vehicle</option>';
    vehicles.forEach(vehicle => {
        vehicleSelect.innerHTML += `<option value="${vehicle.VehicleID}">${vehicle.PlateNumber} - ${vehicle.Make} ${vehicle.Model}</option>`;
    });
    
    // Load locations
    const locationsResponse = await fetch(`${API_URL}/locations`);
    const locations = await locationsResponse.json();
    const originSelect = document.getElementById('trip-origin-select');
    const destinationSelect = document.getElementById('trip-destination-select');
    
    originSelect.innerHTML = '<option value="">Select Origin</option>';
    destinationSelect.innerHTML = '<option value="">Select Destination</option>';
    
    locations.forEach(location => {
        const optionText = `${location.Address}, ${location.City}`;
        originSelect.innerHTML += `<option value="${location.LocationID}">${optionText}</option>`;
        destinationSelect.innerHTML += `<option value="${location.LocationID}">${optionText}</option>`;
    });
}

function hideAddTripForm() {
    document.getElementById('add-trip-form').style.display = 'none';
    document.querySelector('#add-trip-form form').reset();
}

async function addTrip(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    const tripData = {
        DriverID: parseInt(formData.get('driverId')),
        VehicleID: parseInt(formData.get('vehicleId')),
        OriginLocationID: parseInt(formData.get('originId')),
        DestinationLocationID: parseInt(formData.get('destinationId')),
        Distance: parseFloat(formData.get('distance'))
    };
    
    try {
        const response = await fetch(`${API_URL}/trips`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(tripData)
        });
        
        if (response.ok) {
            hideAddTripForm();
            loadTrips();
            alert('Trip started successfully!');
        } else {
            const error = await response.json();
            alert('Error starting trip: ' + error.detail);
        }
    } catch (error) {
        console.error('Error starting trip:', error);
        alert('Error starting trip');
    }
}

async function completeTrip(tripId) {
    try {
        const response = await fetch(`${API_URL}/trips/${tripId}/complete`, {
            method: 'PUT'
        });
        
        if (response.ok) {
            loadTrips();
            alert('Trip completed successfully!');
        } else {
            const error = await response.json();
            alert('Error completing trip: ' + error.detail);
        }
    } catch (error) {
        console.error('Error completing trip:', error);
        alert('Error completing trip');
    }
}

async function cancelTrip(tripId) {
    if (!confirm('Are you sure you want to cancel this trip?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/trips/${tripId}/cancel`, {
            method: 'PUT'
        });
        
        if (response.ok) {
            loadTrips();
            alert('Trip cancelled successfully!');
        } else {
            const error = await response.json();
            alert('Error cancelling trip: ' + error.detail);
        }
    } catch (error) {
        console.error('Error cancelling trip:', error);
        alert('Error cancelling trip');
    }
}

// Maintenance functions
async function loadMaintenance() {
    try {
        const response = await fetch(`${API_URL}/maintenance`);
        const maintenances = await response.json();
        
        const tbody = document.querySelector('#maintenance-table tbody');
        tbody.innerHTML = '';
        
        maintenances.forEach(maintenance => {
            const row = `
                <tr>
                    <td>${maintenance.MaintenanceID}</td>
                    <td>${maintenance.vehicle_info}</td>
                    <td>${maintenance.Description || '-'}</td>
                    <td>${new Date(maintenance.Date).toLocaleString()}</td>
                    <td>$${maintenance.Cost}</td>
                    <td>${maintenance.PerformedBy || '-'}</td>
                    <td>
                        <span class="status-${maintenance.MaintenanceStatus.toLowerCase()}">${maintenance.MaintenanceStatus}</span>
                    </td>
                    <td>
                        ${maintenance.MaintenanceStatus === 'Ongoing' ? 
                            `<button class="btn btn-success action-btn" onclick="completeMaintenance(${maintenance.MaintenanceID})">Complete</button>` 
                            : '-'}
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading maintenance:', error);
    }
}

async function showAddMaintenanceForm() {
    document.getElementById('add-maintenance-form').style.display = 'block';
    
    // Load vehicles
    const vehiclesResponse = await fetch(`${API_URL}/vehicles`);
    const vehicles = await vehiclesResponse.json();
    const vehicleSelect = document.getElementById('maintenance-vehicle-select');
    vehicleSelect.innerHTML = '<option value="">Select Vehicle</option>';
    vehicles.forEach(vehicle => {
        vehicleSelect.innerHTML += `<option value="${vehicle.VehicleID}">${vehicle.PlateNumber} - ${vehicle.Make} ${vehicle.Model}</option>`;
    });
}

function hideAddMaintenanceForm() {
    document.getElementById('add-maintenance-form').style.display = 'none';
    document.querySelector('#add-maintenance-form form').reset();
}

async function addMaintenance(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    const maintenanceData = {
        VehicleID: parseInt(formData.get('vehicleId')),
        Description: formData.get('description'),
        Cost: parseFloat(formData.get('cost')),
        PerformedBy: formData.get('performedBy')
    };
    
    try {
        const response = await fetch(`${API_URL}/maintenance`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(maintenanceData)
        });
        
        if (response.ok) {
            hideAddMaintenanceForm();
            loadMaintenance();
            alert('Maintenance record added successfully!');
        } else {
            const error = await response.json();
            alert('Error adding maintenance: ' + error.detail);
        }
    } catch (error) {
        console.error('Error adding maintenance:', error);
        alert('Error adding maintenance');
    }
}

async function completeMaintenance(maintenanceId) {
    try {
        const response = await fetch(`${API_URL}/maintenance/${maintenanceId}/complete`, {
            method: 'PUT'
        });
        
        if (response.ok) {
            loadMaintenance();
            alert('Maintenance completed successfully!');
        } else {
            const error = await response.json();
            alert('Error completing maintenance: ' + error.detail);
        }
    } catch (error) {
        console.error('Error completing maintenance:', error);
        alert('Error completing maintenance');
    }
}

// Fuel Log functions
async function loadFuelLogs() {
    try {
        const response = await fetch(`${API_URL}/fuel-logs`);
        const fuelLogs = await response.json();
        
        const tbody = document.querySelector('#fuel-table tbody');
        tbody.innerHTML = '';
        
        fuelLogs.forEach(log => {
            const row = `
                <tr>
                    <td>${log.FuelLogID}</td>
                    <td>${log.vehicle_info}</td>
                    <td>${new Date(log.Date).toLocaleDateString()}</td>
                    <td>${log.FuelType || '-'}</td>
                    <td>${log.Quantity || '-'}</td>
                    <td>$${log.Cost}</td>
                    <td>-</td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading fuel logs:', error);
    }
}

async function showAddFuelForm() {
    document.getElementById('add-fuel-form').style.display = 'block';
    
    // Load vehicles
    const vehiclesResponse = await fetch(`${API_URL}/vehicles`);
    const vehicles = await vehiclesResponse.json();
    const vehicleSelect = document.getElementById('fuel-vehicle-select');
    vehicleSelect.innerHTML = '<option value="">Select Vehicle</option>';
    vehicles.forEach(vehicle => {
        vehicleSelect.innerHTML += `<option value="${vehicle.VehicleID}">${vehicle.PlateNumber} - ${vehicle.Make} ${vehicle.Model}</option>`;
    });
}

function hideAddFuelForm() {
    document.getElementById('add-fuel-form').style.display = 'none';
    document.querySelector('#add-fuel-form form').reset();
}

async function addFuelLog(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    const fuelData = {
        VehicleID: parseInt(formData.get('vehicleId')),
        FuelType: formData.get('fuelType'),
        Quantity: formData.get('quantity') ? parseFloat(formData.get('quantity')) : null,
        Cost: parseFloat(formData.get('cost'))
    };
    
    try {
        const response = await fetch(`${API_URL}/fuel-logs`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(fuelData)
        });
        
        if (response.ok) {
            hideAddFuelForm();
            loadFuelLogs();
            alert('Fuel log added successfully!');
        } else {
            const error = await response.json();
            alert('Error adding fuel log: ' + error.detail);
        }
    } catch (error) {
        console.error('Error adding fuel log:', error);
        alert('Error adding fuel log');
    }
}

// Violations functions
async function loadViolations() {
    try {
        const response = await fetch(`${API_URL}/violations`);
        const violations = await response.json();
        
        const tbody = document.querySelector('#violations-table tbody');
        tbody.innerHTML = '';
        
        violations.forEach(violation => {
            const row = `
                <tr>
                    <td>${violation.ViolationID}</td>
                    <td>${violation.vehicle_info}</td>
                    <td>${new Date(violation.Date).toLocaleString()}</td>
                    <td>${violation.Description || '-'}</td>
                    <td>$${violation.PenaltyAmount}</td>
                    <td>-</td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading violations:', error);
    }
}

async function showAddViolationForm() {
    document.getElementById('add-violation-form').style.display = 'block';
    
    // Load vehicles
    const vehiclesResponse = await fetch(`${API_URL}/vehicles`);
    const vehicles = await vehiclesResponse.json();
    const vehicleSelect = document.getElementById('violation-vehicle-select');
    vehicleSelect.innerHTML = '<option value="">Select Vehicle</option>';
    vehicles.forEach(vehicle => {
        vehicleSelect.innerHTML += `<option value="${vehicle.VehicleID}">${vehicle.PlateNumber} - ${vehicle.Make} ${vehicle.Model}</option>`;
    });
}

function hideAddViolationForm() {
    document.getElementById('add-violation-form').style.display = 'none';
    document.querySelector('#add-violation-form form').reset();
}

async function addViolation(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    const violationData = {
        VehicleID: parseInt(formData.get('vehicleId')),
        Description: formData.get('description'),
        PenaltyAmount: parseFloat(formData.get('penaltyAmount'))
    };
    
    try {
        const response = await fetch(`${API_URL}/violations`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(violationData)
        });
        
        if (response.ok) {
            hideAddViolationForm();
            loadViolations();
            alert('Violation added successfully!');
        } else {
            const error = await response.json();
            alert('Error adding violation: ' + error.detail);
        }
    } catch (error) {
        console.error('Error adding violation:', error);
        alert('Error adding violation');
    }
}

// Advanced Queries functions
async function executeQuery(queryType) {
    try {
        let endpoint = '';
        let requiresInput = false;
        let inputValue = null;
        
        switch(queryType) {
            case 'ongoing-trips-view':
                endpoint = '/queries/ongoing-trips';
                break;
            case 'available-vehicles-view':
                endpoint = '/queries/available-vehicles';
                break;
            case 'violations-details-view':
                endpoint = '/queries/violations-details';
                break;
            case 'vehicle-cost-analysis':
                endpoint = '/queries/vehicle-cost-analysis';
                break;
            case 'daily-operations':
                endpoint = '/queries/daily-operations';
                break;
            case 'driver-trips-history':
                requiresInput = true;
                inputValue = prompt('Enter Driver ID:');
                if (!inputValue) return;
                endpoint = `/queries/driver-trips/${inputValue}`;
                break;
            case 'vehicle-maintenance-history':
                requiresInput = true;
                inputValue = prompt('Enter Vehicle ID:');
                if (!inputValue) return;
                endpoint = `/queries/vehicle-maintenance/${inputValue}`;
                break;
            case 'drivers-performance':
                endpoint = '/queries/drivers-performance';
                break;
            case 'top-drivers-manufacturer':
                endpoint = '/queries/top-drivers-manufacturer';
                break;
            case 'most-driven-vehicles':
                endpoint = '/queries/most-driven-vehicles';
                break;
            case 'maintenance-expenses':
                endpoint = '/queries/maintenance-expenses';
                break;
            case 'driver-performance-percentiles':
                endpoint = '/queries/driver-performance-percentiles';
                break;
            case 'loyal-maintenance-providers':
                endpoint = '/queries/loyal-maintenance-providers';
                break;
            case 'safe-drivers-unsafe-vehicles':
                endpoint = '/queries/safe-drivers-unsafe-vehicles';
                break;
            case 'vehicle-distance-milestones':
                endpoint = '/queries/vehicle-distance-milestones';
                break;
            case 'route-efficiency-rankings':
                endpoint = '/queries/route-efficiency-rankings';
                break;
            case 'vehicle-trip-evolution':
                endpoint = '/queries/vehicle-trip-evolution';
                break;
            case 'maintenance-cost-analysis':
                endpoint = '/queries/maintenance-cost-analysis';
                break;
            case 'driver-tenure-analysis':
                endpoint = '/queries/driver-tenure-analysis';
                break;
            case 'driver-violation-rankings':
                endpoint = '/queries/driver-violation-rankings';
                break;
            case 'fuel-efficiency-analysis':
                endpoint = '/queries/fuel-efficiency-analysis';
                break;
            case 'drivers-never-violated':
                endpoint = '/queries/drivers-never-violated';
                break;
            case 'vehicles-no-maintenance':
                endpoint = '/queries/vehicles-no-maintenance';
                break;
            case 'drivers-above-average-distance':
                endpoint = '/queries/drivers-above-average-distance';
                break;
        }
        const response = await fetch(`${API_URL}${endpoint}`);
        const result = await response.json();
        
        // Store the SQL query
        currentQuerySQL = result.sql_query;
        
        // Display results
        displayQueryResults(queryType, result.data);
        
    } catch (error) {
        console.error('Error executing query:', error);
        alert('Error executing query');
    }
}

function displayQueryResults(queryType, data) {
    const resultsDiv = document.getElementById('query-results');
    const titleElement = document.getElementById('query-result-title');
    const contentDiv = document.getElementById('query-result-content');
    
    resultsDiv.style.display = 'block';
    
    // Set title based on query type
    const titles = {
        'ongoing-trips-view': 'Ongoing Trips',
        'available-vehicles-view': 'Available Vehicles',
        'violations-details-view': 'Violations Details',
        'vehicle-cost-analysis': 'Vehicle Cost Analysis',
        'daily-operations': 'Daily Operations Summary',
        'driver-trips-history': 'Driver Trips History',
        'vehicle-maintenance-history': 'Vehicle Maintenance History'
    };
    
    titleElement.textContent = titles[queryType] || 'Query Results';
    
    // Create table from data
    if (data && data.length > 0) {
        let table = '<table><thead><tr>';
        
        // Get headers from first row
        const headers = Object.keys(data[0]);
        headers.forEach(header => {
            table += `<th>${header}</th>`;
        });
        table += '</tr></thead><tbody>';
        
        // Add data rows
        data.forEach(row => {
            table += '<tr>';
            headers.forEach(header => {
                table += `<td>${row[header] !== null ? row[header] : '-'}</td>`;
            });
            table += '</tr>';
        });
        
        table += '</tbody></table>';
        contentDiv.innerHTML = table;
    } else {
        contentDiv.innerHTML = '<p>No data found.</p>';
    }
}

// SQL Query Display functions
const sqlQueries = {
    'dashboard-stats': `-- Dashboard Statistics Query
SELECT 
    (SELECT COUNT(*) FROM driver WHERE DriverID > 0) as total_drivers,
    (SELECT COUNT(*) FROM vehicle WHERE VehicleStatus = 'Available' AND VehicleID > 0) as available_vehicles,
    (SELECT COUNT(*) FROM trip WHERE TripStatus = 'Ongoing') as ongoing_trips,
    (SELECT COUNT(*) FROM vehicle WHERE VehicleStatus = 'In Maintenance' AND VehicleID > 0) as vehicles_in_maintenance;`,
    
    'select-drivers': `-- Select All Drivers
SELECT 
    DriverID,
    FirstName,
    LastName,
    LicenseNumber,
    Phone,
    Email,
    HireDate
FROM driver
WHERE DriverID > 0
ORDER BY DriverID;`,
    
    'select-vehicles': `-- Select All Vehicles
SELECT 
    VehicleID,
    PlateNumber,
    Make,
    Model,
    Year,
    VehicleStatus,
    OdometerReading
FROM vehicle
WHERE VehicleID > 0
ORDER BY VehicleID;`,
    
    'select-trips': `-- Select All Trips with Details
SELECT 
    t.TripID,
    CONCAT(d.FirstName, ' ', d.LastName) AS driver_name,
    v.PlateNumber AS vehicle_plate,
    CONCAT(origin.Address, ', ', origin.City) AS origin,
    CONCAT(dest.Address, ', ', dest.City) AS destination,
    t.StartTime,
    t.EndTime,
    t.Distance,
    t.TripStatus
FROM trip t
    JOIN driver d ON t.DriverID = d.DriverID
    JOIN vehicle v ON t.VehicleID = v.VehicleID
    LEFT JOIN location origin ON t.OriginLocationID = origin.LocationID
    LEFT JOIN location dest ON t.DestinationLocationID = dest.LocationID
ORDER BY t.TripID DESC;`,
    
    'select-maintenance': `-- Select All Maintenance Records
SELECT 
    m.MaintenanceID,
    m.Date,
    CONCAT(v.PlateNumber, ' - ', v.Make, ' ', v.Model) AS vehicle_info,
    m.Description,
    m.Cost,
    m.PerformedBy,
    m.MaintenanceStatus
FROM maintenance m
    JOIN vehicle v ON m.VehicleID = v.VehicleID
ORDER BY m.Date DESC;`,
    
    'select-fuel': `-- Select All Fuel Logs
SELECT 
    f.FuelLogID,
    f.Date,
    CONCAT(v.PlateNumber, ' - ', v.Make, ' ', v.Model) AS vehicle_info,
    f.FuelType,
    f.Quantity,
    f.Cost
FROM fuellog f
    JOIN vehicle v ON f.VehicleID = v.VehicleID
ORDER BY f.Date DESC;`,
    
    'select-violations': `-- Select All Violations
SELECT 
    vio.ViolationID,
    vio.Date,
    CONCAT(v.PlateNumber, ' - ', v.Make, ' ', v.Model) AS vehicle_info,
    vio.Description,
    vio.PenaltyAmount
FROM violation vio
    JOIN vehicle v ON vio.VehicleID = v.VehicleID
ORDER BY vio.Date DESC;`
};

function showQuery(queryKey) {
    const modal = document.getElementById('sql-modal');
    const queryDisplay = document.getElementById('sql-query-display');
    
    if (sqlQueries[queryKey]) {
        queryDisplay.textContent = sqlQueries[queryKey];
        modal.style.display = 'block';
        
        // Scroll to top of modal content
        queryDisplay.scrollTop = 0;
        
        // Ensure modal is visible by scrolling page to top
        window.scrollTo(0, 0);
    }
}

function showQuerySQL() {
    const modal = document.getElementById('sql-modal');
    const queryDisplay = document.getElementById('sql-query-display');
    
    if (currentQuerySQL) {
        queryDisplay.textContent = currentQuerySQL;
        modal.style.display = 'block';
        
        // Scroll to top of modal content
        queryDisplay.scrollTop = 0;
        
        // Ensure modal is visible by scrolling page to top
        window.scrollTo(0, 0);
    }
}

function closeSQLModal() {
    document.getElementById('sql-modal').style.display = 'none';
}

function copySQL() {
    const queryText = document.getElementById('sql-query-display').textContent;
    navigator.clipboard.writeText(queryText).then(() => {
        alert('SQL query copied to clipboard!');
    }).catch(err => {
        console.error('Error copying SQL:', err);
    });
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('sql-modal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
}

// Load dashboard on page load
window.onload = function() {
    loadDashboard();
};

// Add some CSS for status indicators
const style = document.createElement('style');
style.textContent = `
    .status-available { color: #27ae60; font-weight: bold; }
    .status-in-trip { color: #3498db; font-weight: bold; }
    .status-in-maintenance { color: #f39c12; font-weight: bold; }
    .status-unavailable { color: #e74c3c; font-weight: bold; }
    .status-ongoing { color: #3498db; font-weight: bold; }
    .status-completed { color: #27ae60; font-weight: bold; }
    .status-canceled { color: #e74c3c; font-weight: bold; }
`;
document.head.appendChild(style);