PRAGMA foreign_keys = ON;

-- DROP TABLE replies;
-- DROP TABLE question_likes;
-- DROP TABLE question_follows;
-- DROP TABLE questions;
-- DROP TABLE users;


CREATE TABLE users ( 
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL, 
  lname VARCHAR(255) NOT NULL

); 

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);
      -- aka to_join_questions_and_users  
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,

  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,

  
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,

  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO 
  users (fname, lname)
VALUES
  ('Ahmed', 'Ali'),
  ('Nick', 'Karsant');

INSERT INTO 
  questions (title, body, author_id)
VALUES  
  ('Where do babies come from?', 'Im suppossed to have a new baby brother soon but where does he come from?', (SELECT id FROM users WHERE fname = 'Ahmed' )),
  ('Why is the sky blue?', 'Does it reflect the color of the ocean?', (SELECT id FROM users WHERE fname = 'Nick' ));


-- What is question_follows_intending to do, what should we SELECT and WHY?
INSERT INTO  
  question_follows(user_id, question_id)
VALUES 
  ( (SELECT id FROM users WHERE id = 1), (SELECT id FROM questions WHERE id = 1)  );


INSERT INTO 
  replies (body, author_id, question_id, parent_id)
VALUES 
  ( 
    'When a momy and daddy love each other...',
  (SELECT id FROM users WHERE id = 1 ),
  (SELECT id FROM questions WHERE  id = 1),  
  (SELECT id FROM replies WHERE parent_id = NULL)
  ),

  (
    'A stork brings it',
  (SELECT id FROM users WHERE id = 2 ),
  (SELECT id FROM questions WHERE  id = 1),  
  (SELECT id FROM replies WHERE parent_id = 1) 


  );

  INSERT INTO 
    question_likes (user_id, question_id)
  VALUES
    ( (SELECT id FROM users WHERE id = 1 ),
    (SELECT id FROM questions WHERE id = 2)
    );













