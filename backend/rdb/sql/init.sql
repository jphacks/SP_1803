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