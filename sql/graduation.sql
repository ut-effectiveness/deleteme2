/* Graduation Query from Export */
   SELECT a.student_id AS headcount,
          a.graduation_date,
          a.degree_id AS primary_degree_id,
          CASE WHEN a.degree_id IN ('MMFT', 'MAT', 'MACC', 'MA') THEN 'Masters'
              WHEN a.degree_id IN ('CERT', 'CER1', 'CER0') THEN 'Certificate'
              WHEN a.degree_id IN ('AA', 'AAS', 'AS', 'AB', 'AC', 'APE') THEN 'Associates'
              WHEN a.degree_id IN ('BA', 'BAS', 'BFA', 'BIS','BM', 'BS', 'BSN') THEN 'Bachelors'
                  ELSE 'ERROR'
                      END "Degree",
          CASE WHEN a.graduated_term_id IN ('202230', '202240', '202320') THEN '2022-23'
               WHEN a.graduated_term_id IN ('202130', '202140', '202220') THEN '2021-22'
               WHEN a.graduated_term_id IN ('202030', '202040', '202120') THEN '2020-21'
               WHEN a.graduated_term_id IN ('201930', '201940', '202020') THEN '2019-20'
               WHEN a.graduated_term_id IN ('201830', '201840', '201920') THEN '2018-19'
               WHEN a.graduated_term_id IN ('201730', '201740', '201820') THEN '2017-18'
                   ELSE 'ERROR'
                       END "reporting_year",
          a.level_id,
          --a.graduated_academic_year_code,
          e.term_desc,
          a.graduated_term_id,
          e.season,
          d.college_desc,
          a.primary_major_desc,
          d.college_abbrv,
          a.degree_desc,
          e.academic_year_code,
          e.academic_year_desc
     FROM export.degrees_awarded a
LEFT JOIN export.student_term_level b
       ON b.student_id = a.student_id
      AND b.level_id = a.level_id
      AND b.term_id = a.graduated_term_id
LEFT JOIN export.student c
       ON c.student_id = a.student_id
LEFT JOIN export.academic_programs d
       ON d.program_id = a.primary_program_id
LEFT JOIN export.term e
       ON e.term_id = a.graduated_term_id
    WHERE a.degree_status_code = 'AW'
      AND EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM graduation_date) <= 6 -- Past 6 years
