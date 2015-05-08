CREATE OR REPLACE FORCE VIEW Manual_Sections_V AS 
SELECT
seq_no
manual_code
chapter_code
section_code
section_title
section_summary
page_no
file_name
ammendment
effectivity_date
remarks
,zsi_lib.GetDescription('S004_T08400','manual_title','manual_code',manual_code) as manual_title
,zsi_lib.GetDescription('S004_T08401','chapter_title','chapter_code',chapter_code) as chapter_title
FROM S004_T08402;
