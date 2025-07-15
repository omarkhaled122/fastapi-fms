# **FastAPI Fleet Management System (FMS)**

This is a FastAPI-based web application connected to a MySQL database.
Follow the steps below to set it up and run it on your machine.

---

## ✅ **1. Requirements**

### **1.1. Install Python**

Make sure you have **Python 3.8 or higher** installed.

### **1.2. Install Dependencies**

Open a terminal in the project folder and run:

```bash
pip install -r requirements.txt
```

The main packages are:

* **FastAPI** – for the web framework
* **Uvicorn** – for running the FastAPI server
* **mysql-connector-python** – for connecting to MySQL

If `pip` is not recognized, use `python -m pip` instead.

---

## ✅ **2. Set Up the Database**

### **2.1. Install MySQL**

If you don’t have MySQL installed, download it from:
[https://dev.mysql.com/downloads/](https://dev.mysql.com/downloads/)

### **2.2. Create the Database and Import the Dump**

#### **Option A: Using Command Line**

1. Open a terminal and enter:

   ```bash
   mysql -u root -p
   ```

   (If you have no MySQL password, just run `mysql -u root`.)

2. Inside the MySQL prompt, create the database:

   ```sql
   CREATE DATABASE fms;
   EXIT;
   ```

3. Import the SQL dump (`fms.sql`):

   ```bash
   mysql -u root -p fms < fms.sql
   ```

   (Skip `-p` if you have no password.)

---

#### **Option B: Using MySQL Workbench**

1. Open MySQL Workbench.
2. Create a new schema (database) named `fms`.
3. Go to **Server → Data Import** → Select `fms.sql` → Click **Start Import**.

---

### **2.3. Verify Database Connection**

Ensure that your MySQL user and password match the credentials in `main.py`:

```python
DB_CONFIG = {
    "host": "localhost",
    "user": "root",        # change if your MySQL user is different
    "password": "",        # add your MySQL password if you have one
    "database": "fms"
}
```

If you are using a different user or password, update it in `main.py`.

---

## ✅ **3. Run the Application**

1. Start the FastAPI server:

   ```bash
   uvicorn main:app --reload
   ```

2. Open the index.html file in a web browser.

3. To view the FastAPI interactive API docs, open:

   ```
   http://127.0.0.1:8000/docs
   ```

---

## ✅ **4. Project Structure**

```
your_project/
│── index.html        # Frontend page
│── styles.css        # Styles for the frontend
│── script.js         # JavaScript for frontend interactions
│── main.py           # FastAPI backend application
│── requirements.txt  # Python dependencies
│── fms.sql           # SQL dump to replicate the database
│── README.txt        # (this file)
```

---

## ✅ **5. Troubleshooting**

* **MySQL Connection Error:**

  * Make sure MySQL is running.
  * Check your username and password in `main.py`.

* **Port Already in Use:**

  * Run Uvicorn on another port:

    ```bash
    uvicorn main:app --host 127.0.0.1 --port 8080 --reload
    ```

* **Pip Install Issues:**

  * Upgrade pip:

    ```bash
    python -m pip install --upgrade pip
    ```

---

### ✅ **Now you’re ready to use the application!**

If you face any issues, check your Python, MySQL, and package versions.
