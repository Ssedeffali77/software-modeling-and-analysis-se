
IF OBJECT_ID('SetDefaultRole', 'TR') IS NOT NULL DROP TRIGGER SetDefaultRole;
GO
IF OBJECT_ID('CheckCourseCapacity', 'TR') IS NOT NULL DROP TRIGGER CheckCourseCapacity;
GO
IF OBJECT_ID('UpdateProgressOnReview', 'TR') IS NOT NULL DROP TRIGGER UpdateProgressOnReview;
GO

-- Автоматично задаване на ролята на нов потребител
CREATE TRIGGER SetDefaultRole
ON Users
AFTER INSERT
AS
BEGIN
    UPDATE Users
    SET Role = 'Student'
    WHERE Role IS NULL AND UserID IN (SELECT UserID FROM inserted);
END;
GO

-- Ограничение на капацитета на курса
CREATE TRIGGER CheckCourseCapacity
ON Enrollments
AFTER INSERT
AS
BEGIN
    -- Проверка дали броят записани студенти за даден курс надвишава капацитета
    IF EXISTS (
        SELECT 1
        FROM Enrollments e
        JOIN Courses c ON e.CourseID = c.CourseID
        GROUP BY e.CourseID, c.Capacity
        HAVING COUNT(*) > c.Capacity
    )
    BEGIN
        ROLLBACK; -- Отказва записването
        RAISERROR('Курсът е запълнен. Няма места.',16,1);
    END
END;
GO


-- Автоматично обновяване на прогрес при добавяне на ревю
CREATE TRIGGER UpdateProgressOnReview
ON Reviews
AFTER INSERT
AS
BEGIN
    UPDATE Enrollments
    SET Progress = 100
    WHERE CourseID IN (SELECT CourseID FROM inserted)
      AND StudentID IN (SELECT StudentID FROM inserted);
END;
GO





-- TEST 1: SetDefaultRole

INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES ('TR User', 'tr_user_role_001@example.com', 'h', NULL);

SELECT * FROM Users WHERE Email='tr_user_role_001@example.com';



-- TEST 2: CheckCourseCapacity

INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES ('TR Instructor', 'tr_instr_001@example.com', 'h', 'Instructor');
DECLARE @I INT = SCOPE_IDENTITY();

INSERT INTO Categories (Name, Description)
VALUES ('TR_Cat_001','d');
DECLARE @C INT = SCOPE_IDENTITY();

INSERT INTO Courses (Title, CategoryID, InstructorID, Description, Capacity)
VALUES ('TR_Course_001', @C, @I, 'd', 1);
DECLARE @Course INT = SCOPE_IDENTITY();

INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES ('TR Student1', 'tr_st1_001@example.com', 'h', 'Student');
DECLARE @S1 INT = SCOPE_IDENTITY();

INSERT INTO Enrollments (StudentID, CourseID)
VALUES (@S1, @Course);

INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES ('TR Student2', 'tr_st2_001@example.com', 'h', 'Student');
DECLARE @S2 INT = SCOPE_IDENTITY();

BEGIN TRY
    INSERT INTO Enrollments (StudentID, CourseID)
    VALUES (@S2, @Course);
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT * FROM Enrollments WHERE CourseID = @Course;



-- TEST 3: UpdateProgressOnReview

INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES ('TR Student3', 'tr_st3_001@example.com', 'h', 'Student');
DECLARE @S3 INT = SCOPE_IDENTITY();

INSERT INTO Users (FullName, Email, PasswordHash, Role)
VALUES ('TR Instructor3', 'tr_instr3_001@example.com', 'h', 'Instructor');
DECLARE @I3 INT = SCOPE_IDENTITY();

INSERT INTO Categories (Name, Description)
VALUES ('TR_Cat_003','d');
DECLARE @C3 INT = SCOPE_IDENTITY();

INSERT INTO Courses (Title, CategoryID, InstructorID, Description, Capacity)
VALUES ('TR_Course_003', @C3, @I3, 'd', 5);
DECLARE @Course3 INT = SCOPE_IDENTITY();

INSERT INTO Enrollments (StudentID, CourseID, Progress)
VALUES (@S3, @Course3, 20);

INSERT INTO Reviews (StudentID, CourseID, Rating, Comment)
VALUES (@S3, @Course3, 5, 'ok');

SELECT * FROM Enrollments
WHERE StudentID = @S3 AND CourseID = @Course3;

