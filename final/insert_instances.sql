-- ======================================================================
--  Name:    insert_instances.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

-- Open the log file.
SPOOL insert_instances.txt

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, man_t(1, 'Man', 'Boromir', 'Men'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, man_t(2, 'Man', 'Faramir', 'Men'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, hobbit_t(3, 'Hobbit', 'Bilbo', 'Hobbits'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, hobbit_t(4, 'Hobbit', 'Frodo', 'Hobbits'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, hobbit_t(5, 'Hobbit', 'Merry', 'Hobbits'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, hobbit_t(6, 'Hobbit', 'Pippin', 'Hobbits'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, hobbit_t(7, 'Hobbit', 'Samwise', 'Hobbits'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, dwarf_t(8, 'Dwarf', 'Gimli', 'Dwarves'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, noldor_t(9, 'Elf', 'Feanor', 'Elves', 'Noldor'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, silvan_t(10, 'Elf', 'Tauriel', 'Elves', 'Silvan'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, teleri_t(11, 'Elf', 'Earwen', 'Elves', 'Teleri'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, teleri_t(12, 'Elf', 'Celebirn', 'Elves', 'Teleri'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, sindar_t(13, 'Elf', 'Thranduil', 'Elves', 'Sindar'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, sindar_t(14, 'Elf', 'Legolas', 'Elves', 'Sindar'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, orc_t(15, 'Orc', 'Azog the Defiler', 'Orcs'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, orc_t(16, 'Orc', 'Bolg', 'Orcs'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, maia_t(17, 'Maia', 'Gandolf the Grey', 'Maiar'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, maia_t(18, 'Maia', 'Radagast the Brown', 'Maiar'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, maia_t(19, 'Maia', 'Saruman the White', 'Maiar'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, goblin_t(20, 'Goblin', 'The Great Goblin', 'Goblins'));

INSERT INTO tolkien 
VALUES 
( tolkien_s.NEXTVAL, man_t(21, 'Man', 'Aragorn', 'Men'));

show errors;

-- Close the log file.
SPOOL OFF

QUIT;
