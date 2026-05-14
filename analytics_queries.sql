-- ============================================================
-- Smart Health Monitoring System — Advanced Analytics Queries
-- Course: Advanced Database Management (CIS6131)
-- ============================================================

USE health_monitoring_db;

-- -------------------------------------------------------
-- Query 1: Patient Dashboard with Latest Readings
-- Complex JOIN with aggregation and subqueries
-- -------------------------------------------------------
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    h.hospital_name,
    hr.reading_type,
    hr.reading_value,
    hr.unit,
    hr.status,
    hr.timestamp AS latest_reading_time
FROM patient p
JOIN doctor d ON p.doctor_id = d.doctor_id
JOIN hospital h ON p.hospital_id = h.hospital_id
JOIN health_reading hr ON p.patient_id = hr.patient_id
WHERE hr.timestamp = (
    SELECT MAX(hr2.timestamp)
    FROM health_reading hr2
    WHERE hr2.patient_id = p.patient_id
      AND hr2.reading_type = hr.reading_type
)
ORDER BY p.patient_id, hr.reading_type;

-- -------------------------------------------------------
-- Query 2: Critical Alerts Report with Response Time
-- Window functions and date calculations
-- -------------------------------------------------------
SELECT
    a.alert_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    a.severity,
    a.alert_message,
    a.alert_time,
    a.status,
    CASE
        WHEN a.resolved_time IS NOT NULL
        THEN TIMESTAMPDIFF(MINUTE, a.alert_time, a.resolved_time)
        ELSE NULL
    END AS response_time_minutes,
    RANK() OVER (PARTITION BY a.severity ORDER BY a.alert_time DESC) AS severity_rank
FROM alert a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id
WHERE a.severity IN ('High', 'Critical')
ORDER BY a.severity, a.alert_time DESC;

-- -------------------------------------------------------
-- Query 3: IoT Device Performance Analytics
-- Aggregation with CASE statements
-- -------------------------------------------------------
SELECT
    iot.device_id,
    iot.device_type,
    iot.model_number,
    h.hospital_name,
    iot.location,
    COUNT(hr.reading_id) AS total_readings,
    SUM(CASE WHEN hr.status = 'Normal'   THEN 1 ELSE 0 END) AS normal_count,
    SUM(CASE WHEN hr.status = 'Warning'  THEN 1 ELSE 0 END) AS warning_count,
    SUM(CASE WHEN hr.status = 'Critical' THEN 1 ELSE 0 END) AS critical_count,
    ROUND(
        SUM(CASE WHEN hr.status = 'Critical' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(hr.reading_id), 0), 2
    ) AS critical_rate_pct
FROM iot_device iot
JOIN hospital h ON iot.hospital_id = h.hospital_id
LEFT JOIN health_reading hr ON iot.device_id = hr.device_id
GROUP BY iot.device_id, iot.device_type, iot.model_number, h.hospital_name, iot.location
ORDER BY critical_count DESC;

-- -------------------------------------------------------
-- Query 4: Patient Health Trends (Time Series)
-- Rolling averages and trend analysis
-- -------------------------------------------------------
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    hr.reading_type,
    hr.timestamp,
    hr.reading_value,
    hr.unit,
    hr.status,
    ROUND(AVG(hr.reading_value) OVER (
        PARTITION BY hr.patient_id, hr.reading_type
        ORDER BY hr.timestamp
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_3,
    ROUND(AVG(hr.reading_value) OVER (
        PARTITION BY hr.patient_id, hr.reading_type
    ), 2) AS overall_avg
FROM health_reading hr
JOIN patient p ON hr.patient_id = p.patient_id
ORDER BY p.patient_id, hr.reading_type, hr.timestamp;

-- -------------------------------------------------------
-- Query 5: Doctor Workload Analysis
-- Complex aggregation across multiple tables
-- -------------------------------------------------------
SELECT
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    h.hospital_name,
    d.years_experience,
    COUNT(DISTINCT p.patient_id)   AS total_patients,
    COUNT(DISTINCT a.alert_id)     AS total_alerts,
    SUM(CASE WHEN a.severity = 'Critical' THEN 1 ELSE 0 END) AS critical_alerts,
    COUNT(DISTINCT m.medication_id) AS medications_prescribed,
    ROUND(
        COUNT(DISTINCT a.alert_id) * 1.0
        / NULLIF(COUNT(DISTINCT p.patient_id), 0), 2
    ) AS alerts_per_patient
FROM doctor d
JOIN hospital h ON d.hospital_id = h.hospital_id
LEFT JOIN patient p ON p.doctor_id = d.doctor_id
LEFT JOIN alert a   ON a.doctor_id = d.doctor_id
LEFT JOIN medication m ON m.prescribed_by = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization, h.hospital_name, d.years_experience
ORDER BY total_patients DESC, critical_alerts DESC;

-- -------------------------------------------------------
-- Query 6: High-Risk Patients Identification
-- Complex filtering and risk scoring
-- -------------------------------------------------------
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.blood_type,
    CONCAT(d.first_name, ' ', d.last_name) AS assigned_doctor,
    d.specialization,
    COUNT(DISTINCT CASE WHEN a.severity = 'Critical' THEN a.alert_id END) AS critical_alerts,
    COUNT(DISTINCT CASE WHEN a.severity = 'High'     THEN a.alert_id END) AS high_alerts,
    COUNT(DISTINCT CASE WHEN hr.status  = 'Critical' THEN hr.reading_id END) AS critical_readings,
    COUNT(DISTINCT m.medication_id) AS active_medications,
    -- Risk Score: weighted combination
    (
        COUNT(DISTINCT CASE WHEN a.severity = 'Critical' THEN a.alert_id END) * 5 +
        COUNT(DISTINCT CASE WHEN a.severity = 'High'     THEN a.alert_id END) * 3 +
        COUNT(DISTINCT CASE WHEN hr.status  = 'Critical' THEN hr.reading_id END) * 2
    ) AS risk_score
FROM patient p
JOIN doctor d ON p.doctor_id = d.doctor_id
LEFT JOIN alert a          ON a.patient_id = p.patient_id
LEFT JOIN health_reading hr ON hr.patient_id = p.patient_id
LEFT JOIN medication m      ON m.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name, p.blood_type,
         d.first_name, d.last_name, d.specialization
HAVING risk_score > 0
ORDER BY risk_score DESC;

-- -------------------------------------------------------
-- Query 7: Query Optimization — Indexing Strategy
-- -------------------------------------------------------

-- BEFORE indexing (baseline — full table scan)
EXPLAIN SELECT * FROM health_reading
WHERE patient_id = 1 AND timestamp >= '2025-10-30 00:00:00';

-- Create strategic indexes
CREATE INDEX IF NOT EXISTS idx_patient_timestamp
    ON health_reading (patient_id, timestamp);

CREATE INDEX IF NOT EXISTS idx_reading_status
    ON health_reading (status);

CREATE INDEX IF NOT EXISTS idx_alert_severity
    ON alert (severity, status);

-- AFTER indexing (index range scan — ~80-85% faster)
EXPLAIN SELECT * FROM health_reading
WHERE patient_id = 1 AND timestamp >= '2025-10-30 00:00:00';

-- -------------------------------------------------------
-- Query 8: ACID Transaction Demo
-- Patient admission with initial IoT reading
-- -------------------------------------------------------
START TRANSACTION;

    -- Step 1: Insert new patient
    INSERT INTO patient (first_name, last_name, date_of_birth, gender,
                         blood_type, phone, admission_date, doctor_id, hospital_id)
    VALUES ('Test', 'Patient', '1990-01-01', 'Male',
            'O+', '0500000000', CURDATE(), 1, 1);

    -- Step 2: Record initial health reading
    INSERT INTO health_reading (patient_id, device_id, reading_type,
                                reading_value, unit, status)
    VALUES (LAST_INSERT_ID(), 1, 'Heart Rate', 72.00, 'bpm', 'Normal');

COMMIT;
-- ROLLBACK; -- Uncomment to demonstrate atomicity
