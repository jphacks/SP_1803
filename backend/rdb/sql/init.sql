use kawai_database;
create table emotions (
    emotion_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    emotion_name VARCHAR(20) NOT NULL
) engine=InnoDB;

create table images (
    image_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    image_url VARCHAR(500) NOT NULL,
    gender VARCHAR(15) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    emotion_id INT NOT NULL,
    FOREIGN KEY(emotion_id) REFERENCES emotions(emotion_id)
) engine=InnoDB;

insert into emotions (emotion_name) values ("かわいい");
insert into emotions (emotion_name) values ("かっこいい");
insert into emotions (emotion_name) values ("おもしろい");
insert into emotions (emotion_name) values ("きもい");

insert into images (image_url, gender, created_at, emotion_id) values ("https://pbs.twimg.com/profile_images/581025665727655936/9CnwZZ6j.jpg", "male", "2018-10-21 12:34:56", 1);