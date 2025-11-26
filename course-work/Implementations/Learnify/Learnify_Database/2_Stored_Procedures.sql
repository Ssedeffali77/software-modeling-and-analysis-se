

IF OBJECT_ID('AddCourse', 'P') IS NOT NULL DROP PROCEDURE AddCourse;
GO
IF OBJECT_ID('EnrollStudent', 'P') IS NOT NULL DROP PROCEDURE EnrollStudent;
GO
IF OBJECT_ID('GetCoursesByCategory', 'P') IS NOT NULL DROP PROCEDURE GetCoursesByCategory;
GO

-- Добавяне на нов курс
CREATE PROCEDURE AddCourse
    @Title NVARCHAR(150),
    @CategoryID INT,
    @InstructorID INT,
    @Description NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Courses (Title, CategoryID, InstructorID, Description)
    VALUES (@Title, @CategoryID, @InstructorID, @Description);
END;
GO

-- Записване на студент за курс
CREATE PROCEDURE EnrollStudent
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    INSERT INTO Enrollments (StudentID, CourseID, EnrolledAt)
    VALUES (@StudentID, @CourseID, GETDATE());
END;
GO

-- Връща всички курсове от дадена категория
CREATE PROCEDURE GetCoursesByCategory
    @CategoryID INT
AS
BEGIN
    SELECT * FROM Courses WHERE CategoryID = @CategoryID;
END;
GO




