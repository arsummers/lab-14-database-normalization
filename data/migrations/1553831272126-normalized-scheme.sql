-- There doesn't appear to be a demo folder, or a migration file sample to base this off of in the lab instructions so apologies is this isn't set up right. Brief internet search was unhelpful as well.

-- makes a copy of our origin database so we can use it to migrate tables around
CREATE DATABASE lab14_normal WITH TEMPLATE lab14;

-- created a second table for bookshelves in the lab 14_normal database
CREATE TABLE BOOKSHELVES (id SERIAL PRIMARY KEY, name VARCHAR(255));

-- only retrieves unique values from the books table to prevent duplicate pieces of data
INSERT INTO bookshelves(name) SELECT DISTINCT bookshelf FROM books;

-- adds column named bookshelf_id to our books table. Connects each book to a specific bookshelf.
ALTER TABLE books ADD COLUMN bookshelf_id INT;

-- prepares to connect the bookshelf_id and bookshelves tables. Runs on every row in the books table, and updates. Will display a column of the unique ids for the bookshelves
UPDATE books SET bookshelf_id=shelf.id FROM (SELECT * FROM bookshelves) AS shelf WHERE books.bookshelf = shelf.name;

-- Removes the column named bookshelf. It was rendered unnecessary when the bookshelf_id column was made, since bookshelf_id acts as a foreign key
ALTER TABLE books DROP COLUMN bookshelf;

-- lets psql know how bookshelf_id and books are connected by setting bookshelf_id as the foreign key which references the primary key in the bookshelves table.
ALTER TABLE books ADD CONSTRAINT fk_bookshelves FOREIGN KEY (bookshelf_id) REFERENCES bookshelves(id);