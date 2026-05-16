# # India General Elections 2024 – SQL Data Analysis Project

## Overview

This project analyzes the **India General Elections 2024** dataset using **MySQL**.
The project focuses on election result analysis, alliance-wise performance, constituency insights, and state-wise seat distribution.

The analysis is performed using SQL queries on multiple CSV datasets imported into MySQL tables.

---

# Project Objectives

* Analyze total Lok Sabha seats
* Calculate state-wise seat distribution
* Analyze NDA vs I.N.D.I.A alliance performance
* Identify top-performing parties
* Find candidates with highest EVM votes
* Perform constituency-wise and state-wise election analysis
* Practice SQL joins, aggregations, subqueries, CASE statements, and data cleaning

---

# Tech Stack

* **Database:** MySQL 8.0
* **Language:** SQL
* **Tool:** MySQL Workbench
* **Dataset Format:** CSV

---

# Dataset Files

The project uses the following datasets:

| File Name                      | Description                            |
| ------------------------------ | -------------------------------------- |
| `constituencywise_details.csv` | Candidate-wise constituency details    |
| `constituencywise_results.csv` | Winning candidate constituency results |
| `partywise_results.csv`        | Party-wise seat counts                 |
| `statewise_results.csv`        | State and constituency mapping         |
| `states.csv`                   | State master data                      |

---

# Database Schema

## Tables Used

### 1. constituencywise_details

Stores candidate-level vote details.

| Column          | Description                |
| --------------- | -------------------------- |
| id              | Auto Increment Primary Key |
| sn              | Serial Number              |
| candidate       | Candidate Name             |
| party           | Political Party            |
| evm_votes       | EVM Votes                  |
| postal_votes    | Postal Votes               |
| total_votes     | Total Votes                |
| percentage      | Vote Percentage            |
| constituency_id | Constituency ID            |

---

### 2. constituencywise_results

Stores constituency-level winning information.

---

### 3. partywise_results

Stores party-wise seats won.

Additional Column Added:

```sql
ALTER TABLE partywise_results
ADD party_alliance VARCHAR(50);
```

---

### 4. statewise_results

Stores constituency and state mappings.

---

### 5. states

Stores state master information.

---

# Data Import Process

## Create Database

```sql
CREATE DATABASE election;
USE election;
```

---

## Create Table

```sql
CREATE TABLE constituencywise_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sn INT,
    candidate VARCHAR(255),
    party VARCHAR(255),
    evm_votes INT,
    postal_votes INT,
    total_votes INT,
    percentage DECIMAL(5,2),
    constituency_id VARCHAR(10)
);
```

---

## Import CSV File

```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/constituencywise_details.csv'
INTO TABLE constituencywise_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(sn, candidate, party, evm_votes, postal_votes, total_votes, percentage, constituency_id);
```

---

# SQL Analysis Performed

## 1. Total Seats in Lok Sabha

```sql
SELECT COUNT(DISTINCT Parliament_Constituency) AS Total_Seats
FROM constituencywise_results;
```

---

## 2. Total Seats Available in Each State

```sql
SELECT
    s.State AS State_Name,
    COUNT(DISTINCT cr.Parliament_Constituency) AS total_no_of_seats
FROM statewise_results sr
JOIN states s
    ON sr.State_ID = s.State_ID
JOIN constituencywise_results cr
    ON sr.Parliament_Constituency = cr.Parliament_Constituency
GROUP BY s.State
ORDER BY s.State;
```

---

## 3. Total Seats Won by NDA Alliance

```sql
SELECT SUM(Won) AS NDA_Total_Seats_Won
FROM partywise_results
WHERE party_alliance = 'NDA';
```

---

## 4. Total Seats Won by I.N.D.I.A Alliance

```sql
SELECT SUM(Won) AS INDIA_Total_Seats_Won
FROM partywise_results
WHERE party_alliance = 'I.N.D.I.A';
```

---

## 5. Seats Won by Alliance in Each State

```sql
SELECT
    s.State AS State_Name,
    SUM(CASE WHEN TRIM(p.party_alliance) = 'NDA' THEN 1 ELSE 0 END) AS NDA_Seats_Won,
    SUM(CASE WHEN TRIM(p.party_alliance) = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_Seats_Won,
    SUM(CASE WHEN TRIM(p.party_alliance) = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p
    ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr
    ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s
    ON sr.State_ID = s.State_ID
GROUP BY s.State
ORDER BY s.State;
```

---

## 6. Candidate with Highest EVM Votes in Each Constituency

```sql
SELECT
    cr.Constituency_Name,
    cd.Constituency_ID,
    cd.Candidate,
    cd.EVM_Votes
FROM constituencywise_details cd
JOIN (
    SELECT
        Constituency_ID,
        MAX(EVM_Votes) AS Max_EVM_Votes
    FROM constituencywise_details
    GROUP BY Constituency_ID
) mx
ON cd.Constituency_ID = mx.Constituency_ID
AND cd.EVM_Votes = mx.Max_EVM_Votes
JOIN constituencywise_results cr
ON cd.Constituency_ID = cr.Constituency_ID
ORDER BY cd.EVM_Votes DESC
LIMIT 10;
```

---

# Key SQL Concepts Used

* INNER JOIN
* GROUP BY
* ORDER BY
* Aggregate Functions
* CASE Statements
* Subqueries
* DISTINCT
* Data Cleaning with TRIM()
* CSV Import using LOAD DATA INFILE
* Index Optimization

---

# Challenges Faced

## 1. CSV Import Issues

### Problem

Only partial rows were inserted during import.

### Solution

* Removed incorrect primary key constraints
* Used `LOAD DATA INFILE`
* Corrected line terminators (`\r\n`)
* Enabled secure import path

---

## 2. Duplicate Seat Counts

### Problem

Incorrect counts due to duplicate rows after joins.

### Solution

Used:

```sql
COUNT(DISTINCT Parliament_Constituency)
```

---

## 3. Alliance Values Returning Zero

### Problem

Extra spaces in `party_alliance` values.

### Solution

Used:

```sql
TRIM(p.party_alliance)
```

---

# Learning Outcomes

Through this project, I learned:

* Real-world SQL data analysis
* Handling large CSV imports in MySQL
* Query optimization techniques
* Data cleaning in SQL
* Alliance-wise election analysis
* Advanced joins and aggregations

---

# Future Improvements

* Create Power BI Dashboard
* Add constituency-level visualizations
* Build election trend analysis
* Automate ETL process
* Create stored procedures and views

---

# Author
**Akshit Jain**

**SQL Election Analysis Project – India General Elections 2024**

Developed using MySQL and SQL queries for data analysis practice.
