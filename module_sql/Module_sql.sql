use eventsdb;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL
);
CREATE TABLE Events (
    event_id INT primary key AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    city VARCHAR(100) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status ENUM('upcoming','completed','cancelled'),
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);
CREATE TABLE Sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    title VARCHAR(200) NOT NULL,
    speaker_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    registration_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
CREATE TABLE Resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    resource_type ENUM('pdf','image','link'),
    resource_url VARCHAR(255) NOT NULL,
    uploaded_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
SELECT e.title, s.speaker_name
FROM Events e
INNER JOIN Sessions s
ON e.event_id = s.event_id;
select * from sessions;
select * from events;
INSERT INTO Users (user_id, full_name, email, city, registration_date) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York', '2024-12-01'),
(2, 'Bob Smith', 'bob@example.com', 'Los Angeles', '2024-12-05'),
(3, 'Charlie Lee', 'charlie@example.com', 'Chicago', '2024-12-10'),
(4, 'Diana King', 'diana@example.com', 'New York', '2025-01-15'),
(5, 'Ethan Hunt', 'ethan@example.com', 'Los Angeles', '2025-02-01');

INSERT INTO Events (event_id, title, description, city, start_date, end_date, status, organizer_id) VALUES
(1, 'Tech Innovators Meetup', 'A meetup for tech enthusiasts.', 'New York', '2025-06-10 10:00:00', '2025-06-10 16:00:00', 'upcoming', 1),
(2, 'AI & ML Conference', 'Conference on AI and ML advancements.', 'Chicago', '2025-05-15 09:00:00', '2025-05-15 17:00:00', 'completed', 3),
(3, 'Frontend Development Bootcamp', 'Hands-on training on frontend tech.', 'Los Angeles', '2025-07-01 10:00:00', '2025-07-03 16:00:00', 'upcoming', 2);
INSERT INTO Sessions (session_id, event_id, title, speaker_name, start_time, end_time) VALUES
(1, 1, 'Opening Keynote', 'Dr. Tech', '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(2, 1, 'Future of Web Dev', 'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(3, 2, 'AI in Healthcare', 'Charlie Lee', '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(4, 3, 'Intro to HTML5', 'Bob Smith', '2025-07-01 10:00:00', '2025-07-01 12:00:00');
INSERT INTO Registrations (registration_id, user_id, event_id, registration_date) VALUES
(1, 1, 1, '2025-05-01'),
(2, 2, 1, '2025-05-02'),
(3, 3, 2, '2025-04-30'),
(4, 4, 2, '2025-04-28'),
(5, 5, 3, '2025-06-15');
INSERT INTO Resources (resource_id, event_id, resource_type, resource_url, uploaded_at) VALUES
(1, 1, 'pdf', 'https://portal.com/resources/tech_meetup_agenda.pdf', '2025-05-01 10:00:00'),
(2, 2, 'image', 'https://portal.com/resources/ai_poster.jpg', '2025-04-20 09:00:00'),
(3, 3, 'link', 'https://portal.com/resources/html5_docs', '2025-06-25 15:00:00');
INSERT INTO Feedback (feedback_id, user_id, event_id, rating, comments, feedback_date) VALUES
(1, 3, 2, 4, 'Great insights!', '2025-05-16'),
(2, 4, 2, 5, 'Very informative.', '2025-05-16'),
(3, 2, 1, 3, 'Could be better.', '2025-06-11');
SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Sessions;
SELECT * FROM Registrations;
SELECT * FROM Feedback;
SELECT * FROM Resources;
select u.full_name,e.title,r.registration_date  from Users u inner join registrations r on u.user_id=r.user_id 
inner join Events e on  r.event_id=e.event_id;
select u.full_name,f.rating from users u inner join feedback f on u.user_id=f.user_id;
select r.resource_id,r.resource_type,r.resource_url from resources r inner join event e on e.event_id=r.event_id; 
SELECT u.full_name,
       u.city,
       e.start_date,
       e.title
FROM Users u
INNER JOIN Registrations r
ON u.user_id = r.user_id
INNER JOIN Events e
ON e.event_id = r.event_id
WHERE e.status = 'upcoming'
AND u.city = e.city
ORDER BY e.start_date;
select e.title from events e
 inner join registrations r
 on  e.event_id=r.event_id 
 inner join users u
 on r.user_id=u.user_id where status='completed' order by start_date;
 SELECT e.title
FROM Events e
INNER JOIN Registrations r
ON e.event_id = r.event_id
INNER JOIN Users u
ON r.user_id = u.user_id
WHERE e.status = 'completed'
ORDER BY e.start_date;
select u.full_name from users u 
inner join registrations r
on u.user_id=r.user_id 
inner join event e
on r.event_id=e.event_id where e.city='new_york' order by u.full_name;
select count(*) from events e inner join sessions s on e.event_id=s.event_id where time(s.start_time) between '10:00:00' and '12:00:00';
select count(f.feedback_date) as feed,u.user_id from feedback f  join users u on u.user_id=f.user_id  group by u.user_id order by desc limit 5;

SELECT e.title
FROM Events e
LEFT JOIN Sessions s
ON e.event_id = s.event_id
WHERE s.session_id IS NULL;

SELECT u.user_id, u.full_name
FROM Users u
LEFT JOIN Registrations r
ON u.user_id = r.user_id
AND r.registration_date >= CURDATE() - INTERVAL 90 DAY
WHERE r.registration_id IS NULL;
select u.user_id ,u.full_name,r.registration_date from events  e inner join registrations r on e.event_id=r.event_id inner join users u on u.user_id=r.user_id;
select e.event_id,e.title ,s.speaker_name as oranizer from events e inner join sessions s on e.event_id=s.event_id ;
select s.session_id,e.title from sessions s inner join events e on s.event_id=e.event_id ;
select f.rating,u.user_id from feedback f inner join users u on f.user_id=u.user_id ;
select e.event_id ,count(r.registration_id)  as total from events e inner join registrations r on e.event_id=r.event_id group by e.event_id ;
select e.event_id,count(f.rating) from events e inner join feedback f on e.event_id=f.event_id group by e.event_id having count(f.rating)>2 ;
select u.user_id from users u inner join registrations r on u.user_id=r.user_id left join events e on e.event_id=r.event_id where u.user_id is null;
select e.registration_id ,u.full_name from users u right join events e on e.registration_id=u.user_id
select e.status,e.city from events e inner join 