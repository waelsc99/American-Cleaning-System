-- قاعدة بيانات النظام: American Cleaning System
-- مبرمج النظام: وائل سيد حسن

CREATE DATABASE IF NOT EXISTS american_cleaning_system;
USE american_cleaning_system;

-- جدول الموظفين
CREATE TABLE IF NOT EXISTS employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_name VARCHAR(100) NOT NULL,
  job_title VARCHAR(100),
  national_id VARCHAR(20),
  phone VARCHAR(20),
  address VARCHAR(150),
  hire_date DATE,
  salary DECIMAL(10,2)
);

-- جدول الحضور والانصراف
CREATE TABLE IF NOT EXISTS attendance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT,
  attend_date DATE,
  time_in TIME,
  time_out TIME,
  total_hours DECIMAL(5,2),
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- جدول السلف
CREATE TABLE IF NOT EXISTS advances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT,
  advance_date DATE,
  amount DECIMAL(10,2),
  notes VARCHAR(200),
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- جدول المستخدمين
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  password VARCHAR(100),
  role ENUM('admin','user') DEFAULT 'user'
);

-- إضافة المستخدم الافتراضي
INSERT INTO users (username, password, role)
VALUES ('admin', '1234', 'admin');
