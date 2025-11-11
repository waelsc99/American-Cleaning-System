' --- build_access_version.vbs ---
' This script generates the offline version of American Cleaning System
' Developed by: Wael Sayed Hassan
' Version: 1.0 - 2025

Set accessApp = CreateObject("Access.Application")

dbPath = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".") & "\American_Cleaning_System.accdb"
accessApp.NewCurrentDatabase dbPath

With accessApp
    ' Create main tables
    .DoCmd.RunSQL "CREATE TABLE Employees (EmpID AUTOINCREMENT PRIMARY KEY, FullName TEXT(100), JobTitle TEXT(50), Department TEXT(50), HireDate DATE, Salary CURRENCY, Status TEXT(10));"
    .DoCmd.RunSQL "CREATE TABLE Users (UserID AUTOINCREMENT PRIMARY KEY, UserName TEXT(50), Password TEXT(50), Role TEXT(20));"
    .DoCmd.RunSQL "INSERT INTO Users (UserName, Password, Role) VALUES ('admin', '1234', 'Manager');"
    .DoCmd.RunSQL "CREATE TABLE Attendance (ID AUTOINCREMENT PRIMARY KEY, EmpID LONG, AttendDate DATE, AttendTime TIME, LeaveTime TIME, Notes TEXT(100));"
    .DoCmd.RunSQL "CREATE TABLE Loans (LoanID AUTOINCREMENT PRIMARY KEY, EmpID LONG, LoanDate DATE, Amount CURRENCY, Notes TEXT(100));"
    .DoCmd.RunSQL "CREATE TABLE Overtime (OTID AUTOINCREMENT PRIMARY KEY, EmpID LONG, OTDate DATE, Hours DOUBLE, Rate CURRENCY, Notes TEXT(100));"
End With

accessApp.Quit
Set accessApp = Nothing

MsgBox "✅ تم إنشاء الملف بنجاح باسم American_Cleaning_System.accdb في نفس المجلد", vbInformation, "نجاح"
