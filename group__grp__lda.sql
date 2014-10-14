CREATE SCHEMA learn_madlib;
show search_path;
SET search_path TO '$user',learn_madlib,public;

--- http://doc.madlib.net/latest/group__grp__lda.html
-- vocabulary table
CREATE TABLE my_vocab(wordid INT4, word TEXT);
INSERT INTO my_vocab VALUES
    (0, 'code'), (1, 'data'), (2, 'graph'), (3, 'image'),
    (4, 'input'), (5, 'layer'), (6, 'learner'), (7, 'loss'),
    (8, 'model'), (9, 'network'), (10, 'neuron'), (11, 'object'),
    (12, 'output'), (13, 'rate'), (14, 'set'), (15, 'signal'),
    (16, 'sparse'), (17, 'spatial'), (18, 'system'), (19, 'training');

-- training data table
CREATE TABLE my_training
(
    docid INT4,
    wordid INT4,
    count INT4
);
INSERT INTO my_training VALUES
    (0, 0, 2),(0, 3, 2),(0, 5, 1),(0, 7, 1),(0, 8, 1),(0, 9, 1),(0, 11, 1),
    (0, 13, 1), (1, 0, 1),(1, 3, 1),(1, 4, 1),(1, 5, 1),(1, 6, 1),(1, 7, 1),
    (1, 10, 1),(1, 14, 1),(1, 17, 1),(1, 18, 1), (2, 4, 2),(2, 5, 1),(2, 6, 2),
    (2, 12, 1),(2, 13, 1),(2, 15, 1),(2, 18, 2), (3, 0, 1),(3, 1, 2),(3, 12, 3),
    (3, 16, 1),(3, 17, 2),(3, 19, 1), (4, 1, 1),(4, 2, 1),(4, 3, 1),(4, 5, 1),
    (4, 6, 1),(4, 10, 1),(4, 11, 1),(4, 14, 1),(4, 18, 1),(4, 19, 1), (5, 0, 1),
    (5, 2, 1),(5, 5, 1),(5, 7, 1),(5, 10, 1),(5, 12, 1),(5, 16, 1),(5, 18, 1),
    (5, 19, 2),(6, 1, 1),(6, 3, 1),(6, 12, 2),(6, 13, 1),(6, 14, 2),(6, 15, 1),
    (6, 16, 1),(6, 17, 1), (7, 0, 1),(7, 2, 1),(7, 4, 1),(7, 5, 1),(7, 7, 2),
    (7, 8, 1),(7, 11, 1),(7, 14, 1),(7, 16, 1), (8, 2, 1),(8, 4, 4),(8, 6, 2),
    (8, 11, 1),(8, 15, 1),(8, 18, 1), (9, 0, 1),(9, 1, 1),(9, 4, 1),(9, 9, 2),
    (9, 12, 2),(9, 15, 1),(9, 18, 1),(9, 19, 1);

-- testing data
CREATE TABLE my_testing
(
    docid INT4,
    wordid INT4,
    count INT4
);
INSERT INTO my_testing VALUES
    (0, 0, 2),(0, 8, 1),(0, 9, 1),(0, 10, 1),(0, 12, 1),(0, 15, 2),(0, 18, 1),
    (0, 19, 1), (1, 0, 1),(1, 2, 1),(1, 5, 1),(1, 7, 1),(1, 12, 2),(1, 13, 1),
    (1, 16, 1),(1, 17, 1),(1, 18, 1), (2, 0, 1),(2, 1, 1),(2, 2, 1),(2, 3, 1),
    (2, 4, 1),(2, 5, 1),(2, 6, 1),(2, 12, 1),(2, 14, 1),(2, 18, 1), (3, 2, 2),
    (3, 6, 2),(3, 7, 1),(3, 9, 1),(3, 11, 2),(3, 14, 1),(3, 15, 1), (4, 1, 1),
    (4, 2, 2),(4, 3, 1),(4, 5, 2),(4, 6, 1),(4, 11, 1),(4, 18, 2);

---
SELECT madlib.lda_train( 'my_training',
                         'my_model',
                         'my_outdata',
                         20,
                         5,
                         10,
                         5,
                         0.01
                       );


-- The topic description by top-k words
SELECT * FROM madlib.lda_get_topic_desc( 'my_model',
                                         'my_vocab',
                                         'my_topic_desc',
                                         15
                                       );
-- The per-topic word counts
SELECT madlib.lda_get_topic_word_count( 'my_model',
                                        'my_topic_word_count'
                                      );
-- The per-word topic counts
SELECT madlib.lda_get_word_topic_count( 'my_model',
                                        'my_word_topic_count'
                                      );       


-- The per-document topic counts:
SELECT docid, topic_count
FROM my_outdata;
-- The per-document topic assignments:
SELECT docid, words, counts, topic_assignment
FROM my_outdata;    

--
SELECT madlib.lda_predict( 'my_testing',
                           'my_model',
                           'my_pred'
                         ); 


-- The per-document topic counts:
SELECT docid, topic_count
FROM my_pred;
-- The per-document topic assignments:
SELECT docid, words, counts, topic_assignment
FROM my_pred;
--
SELECT madlib.lda_get_perplexity( 'my_model',
                                  'my_pred'
                                );

                                                 