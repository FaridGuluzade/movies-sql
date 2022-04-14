CREATE DATABASE IMDB

USE IMDB


CREATE TABLE Directors(

Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL

)


INSERT INTO Directors
VALUES ('Kenneth','Branagh'),('James','Cameron'),('David','Fincher'),('Martin','Scorsese'),('Matt','Reeves')


CREATE TABLE Movies (

Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL,
Duration INT NOT NULL,
IMD FLOAT(10) NOT NULL,
DirectorId INT FOREIGN KEY REFERENCES Directors(Id)

)

ALTER TABLE Movies
ALTER COLUMN IMD DECIMAL(2,1)

exec sp_rename 'Movies.IMD', IMDB

INSERT INTO Movies 
VALUES ('Belfast',98,7.3,1),
		('Titanic',194,7.9,2),
		('Fight Club',139,8.8,3),
		('The wolf of wall street',180,8.2,4),
		('Batman',176,8.3,5)



CREATE TABLE Actors(

Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL

)

INSERT INTO Actors
VALUES ('Leonardo','Dicaprio'),
		('Brad','Pitt'),
		('Robert','Pattinson'),
		('Jude','Hill')



CREATE TABLE MoviesActors(

Id INT PRIMARY KEY IDENTITY,
MovieId INT FOREIGN KEY REFERENCES Movies(Id),
ActorId  INT FOREIGN KEY REFERENCES Actors(Id)

)

INSERT INTO MoviesActors
VALUES (1,4),(2,1),(3,2),(4,1),(5,3)



SELECT m.Name as [Movie Name],
		a.Name +' ' + a.Surname as [Actor]
from MoviesActors ms
INNER JOIN Movies m on m.Id = ms.MovieId
INNER JOIN Actors a on a.Id = ms.ActorId

		


CREATE TABLE Genres (

Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL,

)

INSERT INTO Genres 
VALUES ('Drama'),('Action'),('Biography'),('Crime'),('Romance'),('History')



CREATE TABLE MoviesGenres (

Id INT PRIMARY KEY IDENTITY,
MovieId INT FOREIGN KEY REFERENCES Movies(Id),
GenreId INT FOREIGN KEY REFERENCES Genres(Id)

)

INSERT INTO MoviesGenres 
VALUES (1,1),(1,3),(1,6),
		(2,1),(2,5),
		(3,1),
		(4,3),(4,4),
		(5,1),(5,2),(5,4)
		




SELECT * FROM Directors
SELECT * FROM MoviesActors
SELECT * FROM MoviesGenres
SELECT * FROM Actors
SELECT * FROM Genres




--1) Imdb point-i 6-dan yuxarı olan filmlərin adını, imdb dəyərini, Genre adını,
--Director adını və aktyor adını gətirən select query-i yazın.
--PS: Men IMDB'ni 8-den yuxari qeyd eledim

SELECT m.Name as [Movie],
		m.IMDB,
		d.Name as [Director],
		a.Name as [Actor],
		g.Name as [Genre]
FROM Movies m
INNER JOIN Directors d on d.Id = m.DirectorId
INNER JOIN MoviesActors ma on ma.MovieId = m.Id
INNER JOIN Actors a on a.Id =ma.ActorId
INNER JOIN MoviesGenres mg on mg.MovieId =m.Id
INNER JOIN Genres g on g.Id =mg.GenreId
WHERE m.IMDB > 8



--2) Genre adında "a" hərfi olan bütün filmlərin adını, imdb dəyərini, Genre adını
--gətirən select query-i yazın.

SELECT m.Name as [Movie],
		m.IMDB,
		g.Name as [Genre]
FROM MoviesGenres mg
INNER JOIN  Movies m on m.Id = mg.MovieId
INNER JOIN Genres g on g.Id = mg.GenreId
WHERE g.Name like '%a%'



--3) Film adının uzunluğu 10-dan böyük olan və film adının sonu "t" hərfiylə bitən bütün
--filmlərin adını, imdb dəyərini, Duration dəyərini, Genre adını gətirən select query-i yazın

SELECT m.Name as [Movie],
		m.IMDB,
		m.Duration as [Duration(min)],
		g.Name as [Genre]
FROM MoviesGenres mg
INNER JOIN Movies m on m.Id = mg.MovieId
INNER JOIN Genres g on g.Id = mg.GenreId
WHERE LEN(m.Name) > 10 and m.Name like '%t'



--4) Imdb point-i ümumi filmlərin imdb point-lərini ortalamasından böyük olan filmlərin
--adını, imdb dəyərini, Genre adını, Director adını və aktyor adını gətirən və imdb dəyərinə
--görə azalan sırayla düzən select query-i yazın

SELECT m.Name as [Movie],
		m.IMDB,
		d.Name as [Director],
		a.Name as [Actor],
		g.Name as [Genre]
FROM Movies m
INNER JOIN Directors d on d.Id = m.DirectorId
INNER JOIN MoviesActors ma on ma.MovieId = m.Id
INNER JOIN Actors a on a.Id =ma.ActorId
INNER JOIN MoviesGenres mg on mg.MovieId =m.Id
INNER JOIN Genres g on g.Id =mg.GenreId
WHERE m.IMDB > (SELECT AVG(IMDB) FROM Movies) 
ORDER BY m.IMDB DESC
				
