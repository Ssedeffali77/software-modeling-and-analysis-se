
IF OBJECT_ID('dbo.GetAverageRating', 'FN') IS NOT NULL DROP FUNCTION dbo.GetAverageRating;
GO
IF OBJECT_ID('dbo.IsEmailUnique', 'FN') IS NOT NULL DROP FUNCTION dbo.IsEmailUnique;
GO
IF OBJECT_ID('dbo.CountStudentsInCourse', 'FN') IS NOT NULL DROP FUNCTION dbo.CountStudentsInCourse;
GO


-- Средна оценка на курс

CREATE FUNCTION dbo.GetAverageRating(@CourseID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Avg FLOAT;

    SELECT @Avg = AVG(CAST(Rating AS FLOAT)) 
    FROM Reviews 
    WHERE CourseID = @CourseID;

    RETURN @Avg;
END;
GO


-- Проверка за уникален имейл

CREATE FUNCTION dbo.IsEmailUnique(@Email NVARCHAR(120))
RETURNS BIT
AS
BEGIN
    DECLARE @Exists INT;

    SELECT @Exists = COUNT(*) 
    FROM Users 
    WHERE Email = @Email;

    RETURN CASE WHEN @Exists = 0 THEN 1 ELSE 0 END;
END;
GO


-- Брой студенти записани на курс

CREATE FUNCTION dbo.CountStudentsInCourse(@CourseID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*) 
    FROM Enrollments 
    WHERE CourseID = @CourseID;

    RETURN @Count;
END;
GO

-- 1. Средна оценка на курс
-- Тествам за курс Основи на C#
DECLARE @CSharpID INT;
SELECT @CSharpID = CourseID FROM Courses WHERE Title = 'Основи на C#';

SELECT dbo.GetAverageRating(@CSharpID) AS AvgRating;

-- 2. Проверка за уникален имейл
SELECT dbo.IsEmailUnique('ivan.ivanov@example.com') AS IsEmailUnique; -- очаква 0
SELECT dbo.IsEmailUnique('newstudent@example.com') AS IsEmailUnique;   -- очаква 1

-- 3. Брой студенти в курс
SELECT dbo.CountStudentsInCourse(@CSharpID) AS StudentsCount;





