成績上位者を上位30%と定義し、その他のグループと比較しました。
その結果、勉強時間や出席率、過去成績に差が見られ、
これらが成績に影響する要因であると考えました。

mysql> WITH ranked AS (
    ->     SELECT
    ->         *,
    ->         PERCENT_RANK() OVER (ORDER BY Exam_Score) AS score_rank
    ->     FROM student_performance
    -> )
    -> SELECT
    ->     CASE
    ->         WHEN score_rank >= 0.7 THEN 'Top'
    ->         ELSE 'Other'
    ->     END AS score_group,
    -> 
    ->     ROUND(AVG(Hours_Studied), 2) AS avg_study,
    ->     ROUND(AVG(Attendance), 2) AS avg_attendance,
    ->     ROUND(AVG(Sleep_Hours), 2) AS avg_sleep,
    ->     ROUND(AVG(Previous_Scores), 2) AS avg_previous,
    ->     ROUND(AVG(Tutoring_Sessions), 2) AS avg_tutoring,
    ->     ROUND(AVG(Physical_Activity), 2) AS avg_activity,
    ->     ROUND(AVG(Exam_Score), 2) AS avg_score
    -> 
    -> FROM ranked
    -> GROUP BY score_group;
+-------------+-----------+----------------+-----------+--------------+--------------+--------------+-----------+
| score_group | avg_study | avg_attendance | avg_sleep | avg_previous | avg_tutoring | avg_activity | avg_score |
+-------------+-----------+----------------+-----------+--------------+--------------+--------------+-----------+
| Other       |     19.88 |          80.05 |         0 |            0 |         0.00 |         7.04 |     67.82 |
| Top         |      20.2 |          79.81 |         0 |            0 |         0.00 |            7 |     92.76 |
+-------------+-----------+----------------+-----------+--------------+--------------+--------------+-----------+
2 rows in set (0.069 sec)



mysql> WITH ranked AS (
    ->     SELECT *,
    ->         CASE
    ->             WHEN PERCENT_RANK() OVER (ORDER BY Exam_Score) >= 0.7 THEN 'Top'
    ->             ELSE 'Other'
    ->         END AS score_group
    ->     FROM student_performance
    -> ),
    -> summary AS (
    ->     SELECT
    ->         score_group,
    ->         AVG(Hours_Studied) AS study,
    ->         AVG(Attendance) AS attendance,
    ->         AVG(Sleep_Hours) AS sleep,
    ->         AVG(Previous_Scores) AS previous
    ->     FROM ranked
    ->     GROUP BY score_group
    -> )
    -> SELECT
    ->     MAX(CASE WHEN score_group='Top' THEN study END)
    ->     - MAX(CASE WHEN score_group='Other' THEN study END) AS diff_study,
    -> 
    ->     MAX(CASE WHEN score_group='Top' THEN attendance END)
    ->     - MAX(CASE WHEN score_group='Other' THEN attendance END) AS diff_attendance,
    -> 
    ->     MAX(CASE WHEN score_group='Top' THEN sleep END)
    ->     - MAX(CASE WHEN score_group='Other' THEN sleep END) AS diff_sleep,
    -> 
    ->     MAX(CASE WHEN score_group='Top' THEN previous END)
    ->     - MAX(CASE WHEN score_group='Other' THEN previous END) AS diff_previous
    -> FROM summary;
+--------------------+---------------------+------------+---------------+
| diff_study         | diff_attendance     | diff_sleep | diff_previous |
+--------------------+---------------------+------------+---------------+
| 0.3210303576860021 | -0.2368339197712146 |          0 |             0 |
+--------------------+---------------------+------------+---------------+
1 row in set (0.099 sec)



mysql> 
mysql> WITH ranked AS (
    ->     SELECT *,
    ->         CASE
    ->             WHEN PERCENT_RANK() OVER (ORDER BY Exam_Score) >= 0.7 THEN 'Top'
    ->             ELSE 'Other'
    ->         END AS score_group
    ->     FROM student_performance
    -> )
    -> SELECT
    ->     score_group,
    ->     Motivation_Level,
    ->     COUNT(*) AS count
    -> FROM ranked
    -> GROUP BY score_group, Motivation_Level
    -> ORDER BY score_group, count DESC;
+-------------+------------------+-------+
| score_group | Motivation_Level | count |
+-------------+------------------+-------+
| Other       | Medium           |  2409 |
| Other       | Low              |  1354 |
| Other       | High             |   923 |
| Top         | Medium           |   942 |
| Top         | Low              |   583 |
| Top         | High             |   396 |
+-------------+------------------+-------+
6 rows in set (0.056 sec)



#データベースを修正前　(SQL)

LOAD DATA LOCAL INFILE '/Users/toruyamaguchi/Downloads/StudentPerformanceFactors.csv'
    -> INTO TABLE student_performance
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS
    -> (Hours_Studied, Attendance, Sleep_Hours, Previous_Scores, Tutoring_Sessions,
    ->  Physical_Activity, Exam_Score, Motivation_Level, Internet_Access,
    ->  Family_Income, Teacher_Quality, School_Type, Peer_Influence,
    ->  Learning_Disabilities, Parental_Education_Level, Distance_from_Home, Gender);
Query OK, 6607 rows affected, 30956 warnings (0.113 sec)
Records: 6607  Deleted: 0  Skipped: 0  Warnings: 30956

mysql> SELECT COUNT(*) FROM student_performance;
+----------+
| COUNT(*) |
+----------+
|     6607 |
+----------+
1 row in set (0.006 sec)

mysql> SELECT Hours_Studied, Sleep_Hours, Previous_Scores, Tutoring_Sessions, Exam_Score
    -> FROM student_performance
    -> LIMIT 10;
+---------------+-------------+-----------------+-------------------+------------+
| Hours_Studied | Sleep_Hours | Previous_Scores | Tutoring_Sessions | Exam_Score |
+---------------+-------------+-----------------+-------------------+------------+
|            23 |           0 |               0 |                 0 |         73 |
|            19 |           0 |               0 |                 0 |         59 |
|            24 |           0 |               0 |                 0 |         91 |
|            29 |           0 |               0 |                 0 |         98 |
|            19 |           0 |               0 |                 0 |         65 |
|            19 |           0 |               0 |                 0 |         89 |
|            29 |           0 |               0 |                 0 |         68 |
|            25 |           0 |               0 |                 0 |         50 |
|            17 |           0 |               0 |                 0 |         80 |
|            23 |           0 |               0 |                 0 |         71 |
+---------------+-------------+-----------------+-------------------+------------+
10 rows in set (0.000 sec)







#データベースを修正(SQL)

LOAD DATA LOCAL INFILE '/Users/toruyamaguchi/Downloads/StudentPerformanceFactors.csv'
    -> INTO TABLE student_performance
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS;
Query OK, 6607 rows affected (0.108 sec)
Records: 6607  Deleted: 0  Skipped: 0  Warnings: 0

mysql> SELECT Sleep_Hours, Previous_Scores, Tutoring_Sessions, Exam_Score
    -> FROM student_performance
    -> LIMIT 10;
+-------------+-----------------+-------------------+------------+
| Sleep_Hours | Previous_Scores | Tutoring_Sessions | Exam_Score |
+-------------+-----------------+-------------------+------------+
|           7 |              73 |                 0 |         67 |
|           8 |              59 |                 2 |         61 |
|           7 |              91 |                 2 |         74 |
|           8 |              98 |                 1 |         71 |
|           6 |              65 |                 3 |         70 |
|           8 |              89 |                 3 |         71 |
|           7 |              68 |                 1 |         67 |
|           6 |              50 |                 1 |         66 |
|           6 |              80 |                 0 |         69 |
|           8 |              71 |                 0 |         72 |
+-------------+-----------------+-------------------+------------+
10 rows in set (0.001 sec)