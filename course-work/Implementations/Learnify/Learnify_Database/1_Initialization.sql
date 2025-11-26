USE LearnifyDB;
GO

IF OBJECT_ID('Reviews', 'U') IS NOT NULL DROP TABLE Reviews;
IF OBJECT_ID('Enrollments', 'U') IS NOT NULL DROP TABLE Enrollments;
IF OBJECT_ID('Modules', 'U') IS NOT NULL DROP TABLE Modules;
IF OBJECT_ID('Courses', 'U') IS NOT NULL DROP TABLE Courses;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('InstructorApplications', 'U') IS NOT NULL
    DROP TABLE InstructorApplications;
GO

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(120) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(200) NOT NULL,
    Role NVARCHAR(30) DEFAULT 'Student' CHECK (Role IN ('Student','Instructor','Admin')),
    CreatedAt DATETIME DEFAULT GETDATE()
);


CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(80) UNIQUE NOT NULL,
    Description NVARCHAR(200)
);


CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(150) UNIQUE NOT NULL,
    Description NVARCHAR(MAX),
    InstructorID INT NOT NULL,
    CategoryID INT NOT NULL,
    Capacity INT DEFAULT 100,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (InstructorID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);


CREATE TABLE Modules (
    ModuleID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    ModuleTitle NVARCHAR(150) NOT NULL,
    ModuleOrder INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrolledAt DATETIME DEFAULT GETDATE(),
    Progress INT DEFAULT 0 CHECK (Progress BETWEEN 0 AND 100),
    UNIQUE (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


