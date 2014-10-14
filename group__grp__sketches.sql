--- http://doc.madlib.net/latest/group__grp__sketches.html

CREATE TABLE data(class INT, a1 INT);
INSERT INTO data SELECT 1,1 FROM generate_series(1,10000);
INSERT INTO data SELECT 1,2 FROM generate_series(1,15000);
INSERT INTO data SELECT 1,3 FROM generate_series(1,10000);
INSERT INTO data SELECT 2,5 FROM generate_series(1,1000);
INSERT INTO data SELECT 2,6 FROM generate_series(1,1000);

--
select distinct class, a1 from data;
--- http://doc.madlib.net/latest/group__grp__mfvsketch.html
SELECT madlib.mfvsketch_top_histogram( a1,
                                5
                              )
FROM data;

-- http://doc.madlib.net/latest/group__grp__countmin.html
SELECT class,
       madlib.cmsketch_count(
                       madlib.cmsketch( a1 ),
                       2
                      )
FROM data GROUP BY data.class;

-- Count number of rows where a1 is between >3 and <=6.
SELECT class,
       madlib.cmsketch_rangecount(
                            madlib.cmsketch(a1),
                            3,
                            6
                          )
FROM data GROUP BY data.class;

-- Compute the 90th percentile of all of a1.
SELECT madlib.cmsketch_centile(
                         madlib.cmsketch( a1 ),
                         90,
                         count(*)
                       )
FROM data;

-- Produce an equi-width histogram with 2 bins between 0 and 10.
SELECT madlib.cmsketch_width_histogram(
                                 madlib.cmsketch( a1 ),
                                 0,
                                 10,
                                 2
                               )
FROM data;

-- Produce an equi-depth histogram of a1 with 2 bins of approximately equal depth.
SELECT madlib.cmsketch_depth_histogram(
                                 madlib.cmsketch( a1 ),
                                 2
                               )
FROM data;

-- http://doc.madlib.net/latest/group__grp__fmsketch.html
SELECT class, madlib.fmsketch_dcount(a1)
FROM data
GROUP BY data.class;
