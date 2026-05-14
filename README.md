# 🏥 Smart Health Monitoring System
### IoT-Enabled Database Application with Query Optimization

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)
![Database](https://img.shields.io/badge/Database-Normalized%20to%20BCNF-green)
![IoT](https://img.shields.io/badge/IoT-Health%20Sensors-orange)
![Performance](https://img.shields.io/badge/Query%20Optimization-85%25%20Faster-brightgreen)

> **Course:** Advanced Database Management (CIS6131) — King Khalid University  
> **Author:** Rana Sultan Alhinidy

---

## 📋 Overview

A comprehensive relational database system that integrates **IoT health sensors** with a robust MySQL backend. The system captures real-time readings from five sensor types, triggers automated critical alerts, manages patient-doctor assignments, and demonstrates production-grade query optimization and ACID-compliant transaction handling.

---

## ✨ Key Features

| Feature | Details |
|---|---|
| 🗄️ **Schema Design** | Fully normalized to BCNF — 7 entities, zero redundancy |
| 📡 **IoT Integration** | 5 sensor types with medical threshold classification |
| ⚡ **Query Optimization** | Strategic indexing achieving **85% faster** query execution |
| 🔒 **ACID Transactions** | InnoDB engine with REPEATABLE READ isolation |
| 🚨 **Alert System** | Automated severity-based alerts (Low / Medium / High / Critical) |
| 📊 **Analytics** | 6 complex queries including window functions and risk scoring |

---

## 🗂️ Repository Structure

```
smart-health-monitoring-db/
│
├── README.md
│
├── schema/
│   ├── smart_health_db.sql       ← Full database dump (CREATE + INSERT)
│   └── erd_diagram.png           ← Entity-Relationship Diagram
│
└── queries/
    └── analytics_queries.sql     ← 8 advanced queries with optimization
```

---

## 🧩 Database Schema

The system models **7 core entities** connected through well-defined relationships:

```
HOSPITAL ──< DOCTOR ──< PATIENT ──< HEALTH_READING >── IOT_DEVICE
                           │
                           ├──< ALERT
                           └──< MEDICATION
```

### Entities & Key Attributes

| Table | Primary Key | Notable Columns |
|---|---|---|
| `hospital` | hospital_id | hospital_name, city, bed_capacity |
| `doctor` | doctor_id | specialization, years_experience |
| `patient` | patient_id | blood_type, admission_date |
| `iot_device` | device_id | device_type, status (Active/Maintenance) |
| `health_reading` | reading_id | reading_value, unit, status (Normal/Warning/Critical) |
| `alert` | alert_id | severity, alert_message, resolved_time |
| `medication` | medication_id | dosage, frequency, end_date |

---

## 📡 IoT Sensor Thresholds

The system classifies all sensor readings automatically based on clinical norms:

| Sensor | Normal | Warning | Critical |
|---|---|---|---|
| Heart Rate | 60–100 bpm | 100–120 bpm | > 120 bpm |
| Blood Pressure | < 140/90 mmHg | 140–160 / 90–95 | > 160/95 mmHg |
| Blood Glucose | < 140 mg/dL | 140–200 mg/dL | > 200 mg/dL |
| Temperature | 36–37.5 °C | 37.5–39 °C | > 39 °C |
| Oxygen Saturation | > 95% | 90–95% | < 90% |

---

## ⚡ Query Optimization Results

Three strategic indexes were implemented to improve performance on the most frequent query patterns:

```sql
-- Composite index for patient time-series queries
CREATE INDEX idx_patient_timestamp ON health_reading (patient_id, timestamp);

-- Index for alert severity filtering
CREATE INDEX idx_alert_severity ON alert (severity, status);

-- Index for status-based reads
CREATE INDEX idx_reading_status ON health_reading (status);
```

| Metric | Before Indexing | After Indexing |
|---|---|---|
| Scan Type | Full table scan (ALL) | Index range scan (ref/range) |
| Execution Time | Baseline | **~85% faster** |

---

## 📊 Analytics Queries

| # | Query | Techniques Used |
|---|---|---|
| 1 | Patient Dashboard — Latest Readings | Complex JOIN + correlated subquery |
| 2 | Critical Alerts + Response Time | Window functions, RANK(), TIMESTAMPDIFF |
| 3 | IoT Device Performance | Aggregation + CASE statements |
| 4 | Health Trends (Time Series) | Rolling average with ROWS BETWEEN |
| 5 | Doctor Workload Analysis | Multi-table aggregation |
| 6 | High-Risk Patient Scoring | Weighted risk score formula |
| 7 | Indexing Strategy Demo | EXPLAIN before/after comparison |
| 8 | ACID Transaction Demo | START TRANSACTION / COMMIT / ROLLBACK |

---

## 🔒 ACID Compliance

The transaction demo (Query 8) shows how the system guarantees data integrity:

- **Atomicity** — Patient insert + reading insert succeed together or roll back together  
- **Consistency** — Foreign key constraints enforced before every commit  
- **Isolation** — REPEATABLE READ prevents dirty reads during concurrent sessions  
- **Durability** — InnoDB write-ahead logging ensures data survives system crashes  

---

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0+
- MySQL Workbench (optional, for visual exploration)

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/smart-health-monitoring-db.git
cd smart-health-monitoring-db

# 2. Import the database
mysql -u root -p < schema/smart_health_db.sql

# 3. Run the analytics queries
mysql -u root -p health_monitoring_db < queries/analytics_queries.sql
```

---

## 🎓 Academic Context

**Normalization levels achieved:**
- ✅ 1NF — Atomic values, no repeating groups  
- ✅ 2NF — No partial dependencies  
- ✅ 3NF — No transitive dependencies  
- ✅ BCNF — Every determinant is a candidate key  

---

## 📄 License

This project was developed for academic purposes at King Khalid University.
