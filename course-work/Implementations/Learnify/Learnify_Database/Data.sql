USE LearnifyDB;
GO


DELETE FROM Reviews;
DBCC CHECKIDENT ('Reviews', RESEED, 0);

DELETE FROM Enrollments;
DBCC CHECKIDENT ('Enrollments', RESEED, 0);

DELETE FROM Modules;
DBCC CHECKIDENT ('Modules', RESEED, 0);

DELETE FROM Courses;
DBCC CHECKIDENT ('Courses', RESEED, 0);

DELETE FROM Categories;
DBCC CHECKIDENT ('Categories', RESEED, 0);

DELETE FROM Users;
DBCC CHECKIDENT ('Users', RESEED, 0);





DECLARE @IvanID INT, @MariaID INT, @GeorgiID INT, @AnnaID INT, @PetarID INT, @ElenaID INT;
DECLARE @ProgID INT, @DesignID INT, @MarketingID INT, @LanguagesID INT;
DECLARE @CSharpID INT, @WebDesignID INT, @MarketingCourseID INT, @EnglishID INT;

INSERT INTO Users (FullName, Email, PasswordHash, Role) VALUES
('Иван Иванов','ivan.ivanov@example.com','hash1','Student'),
('Мария Петрова','maria.petrova@example.com','hash2','Student'),
('Георги Георгиев','georgi.georgiev@example.com','hash3','Instructor'),
('Анна Димитрова','anna.dimitrova@example.com','hash4','Admin'),
('Петър Стоянов','petar.stoyanov@example.com','hash5','Student'),
('Елена Николова','elena.nikolova@example.com','hash6','Instructor');


SELECT @IvanID = UserID FROM Users WHERE FullName='Иван Иванов';
SELECT @MariaID = UserID FROM Users WHERE FullName='Мария Петрова';
SELECT @GeorgiID = UserID FROM Users WHERE FullName='Георги Георгиев';
SELECT @AnnaID = UserID FROM Users WHERE FullName='Анна Димитрова';
SELECT @PetarID = UserID FROM Users WHERE FullName='Петър Стоянов';
SELECT @ElenaID = UserID FROM Users WHERE FullName='Елена Николова';


INSERT INTO Categories (Name, Description) VALUES
('Програмиране','Курсове за програмиране и разработка на софтуер'),
('Дизайн','Курсове по графичен и уеб дизайн'),
('Маркетинг','Курсове по дигитален маркетинг и реклама'),
('Езици','Курсове за чужди езици');

SELECT @ProgID = CategoryID FROM Categories WHERE Name='Програмиране';
SELECT @DesignID = CategoryID FROM Categories WHERE Name='Дизайн';
SELECT @MarketingID = CategoryID FROM Categories WHERE Name='Маркетинг';
SELECT @LanguagesID = CategoryID FROM Categories WHERE Name='Езици';


INSERT INTO Courses (Title, CategoryID, InstructorID, Description, Capacity) VALUES
('Основи на C#', @ProgID, @GeorgiID, 'Курс за начинаещи по програмиране на C#', 30),
('Уеб дизайн с HTML и CSS', @DesignID, @ElenaID, 'Въведение в уеб дизайна', 25),
('Основи на дигиталния маркетинг', @MarketingID, @ElenaID, 'Курс за маркетингови стратегии', 20),
('Английски за начинаещи', @LanguagesID, @GeorgiID, 'Курс за овладяване на базови английски умения', 40);

SELECT @CSharpID = CourseID FROM Courses WHERE Title='Основи на C#';
SELECT @WebDesignID = CourseID FROM Courses WHERE Title='Уеб дизайн с HTML и CSS';
SELECT @MarketingCourseID = CourseID FROM Courses WHERE Title='Основи на дигиталния маркетинг';
SELECT @EnglishID = CourseID FROM Courses WHERE Title='Английски за начинаещи';


INSERT INTO Modules (CourseID, ModuleTitle, ModuleOrder) VALUES 
(@CSharpID,'Преглед на C# и Visual Studio',1),
(@CSharpID,'Променливи и типове данни',2),
(@CSharpID,'Условни конструкции и цикли',3),
(@WebDesignID,'Основи на HTML',1),
(@WebDesignID,'Създаване на CSS стилове',2),
(@MarketingCourseID,'Въведение в маркетинга',1),
(@MarketingCourseID,'Дигитални канали и социални мрежи',2),
(@EnglishID,'Азбука и произношение',1),
(@EnglishID,'Основни изречения и разговори',2);


INSERT INTO Enrollments (StudentID, CourseID, Progress) VALUES 
(@IvanID,@CSharpID,50),
(@MariaID,@WebDesignID,20),
(@PetarID,@MarketingCourseID,10),
(@IvanID,@EnglishID,0),
(@MariaID,@CSharpID,30);


INSERT INTO Reviews (StudentID, CourseID, Rating, Comment) VALUES 
(@IvanID,@CSharpID,5,'Курсът е много полезен и добре обяснен!'),
(@MariaID,@WebDesignID,4,'Интересен курс, научих много нови неща.'),
(@PetarID,@MarketingCourseID,3,'Добър, но можеше да е по-подробен.'),
(@IvanID,@EnglishID,4,'Полезен курс за начинаещи.'),
(@MariaID,@CSharpID,5,'Много полезни примери и упражнения!');

--  Тест на stored procedures
-- a) AddCourse
DECLARE @NewCourseID INT;
EXEC AddCourse 
    @Title='Тест курс', 
    @CategoryID=@ProgID, 
    @InstructorID=@GeorgiID, 
    @Description='Тест на процедурата AddCourse';
SELECT @NewCourseID = CourseID FROM Courses WHERE Title='Тест курс';

-- 2. EnrollStudent
IF @NewCourseID IS NOT NULL
BEGIN
    EXEC EnrollStudent 
        @StudentID=@IvanID, 
        @CourseID=@NewCourseID;

    -- Проверка на записването
    SELECT * FROM Enrollments WHERE CourseID=@NewCourseID AND StudentID=@IvanID;
END
ELSE
BEGIN
    PRINT 'Грешка: @NewCourseID е NULL, записването не може да се извърши.';
END

-- 3. GetCoursesByCategory
DECLARE @CategoryID INT;

-- Взимаме ID на категория "Програмиране"
SELECT @CategoryID = CategoryID 
FROM Categories 
WHERE Name = 'Програмиране';

-- Извикваме процедурата
EXEC GetCoursesByCategory @CategoryID = @CategoryID;





