--- http://doc.madlib.net/latest/group__grp__quantile.html
CREATE TABLE tab1 AS SELECT generate_series(1, 1000) AS col1;

select * from tab1;

SELECT madlib.quantile( 'tab1',
                 'col1',
                 .9
               );

SELECT madlib.quantile_big( 'tab1',
                 'col1',
                 .8
               );               