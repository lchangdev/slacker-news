CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  url VARCHAR(500) NOT NULL,
  description varchar(1000) NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  article_id INTEGER NOT NULL,
  comment VARCHAR(2000) NOT NULL,
  created_at TIMESTAMP NOT NULL
);
