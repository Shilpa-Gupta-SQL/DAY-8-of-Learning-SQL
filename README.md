Day 8 – SQL JOINs (Cross, Inner, Left, Right, Self, Full)
Today I learned how different SQL JOINs work and how they are used to combine data from multiple tables. These concepts are very important for real-world database queries.

✔ CROSS JOIN
Returns every possible combination of rows from both tables (A × B).

✔ INNER JOIN
Returns only the rows that match in both tables.

✔ LEFT JOIN
Returns all rows from the left table and matching rows from the right table.
Non-matching rows show NULL on the right side.

✔ RIGHT JOIN
Returns all rows from the right table and matching rows from the left.
Non-matching rows show NULL on the left side.

✔ FULL JOIN
Returns all matched and unmatched rows from both tables.
(Emulated in MySQL using LEFT JOIN + RIGHT JOIN + UNION)

✔ SELF JOIN
A table joined with itself.
Common for hierarchical data like employee–manager relations.
