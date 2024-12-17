SELECT "DOMAIN", AVG(CORE) Average_CPU_Usage, AVG(DB) Average_DB_Usage 
FROM WEB_STAT 
GROUP BY "DOMAIN" 
ORDER BY "DOMAIN" DESC;

-- Sum, Min and Max CPU usage by Salesforce grouped by day
SELECT extract(DAY from "DATE") Dia, SUM(CORE) TOTAL_CPU_Usage, MIN(CORE) MIN_CPU_Usage, MAX(CORE) MAX_CPU_Usage 
FROM WEB_STAT 
WHERE "DOMAIN" LIKE 'Salesforce%' 
GROUP BY extract(DAY from "DATE");

-- list host and total active users when core CPU usage is 10X greater than DB usage
SELECT "HOST", SUM(ACTIVE_VISITOR) TOTAL_ACTIVE_VISITORS 
FROM WEB_STAT 
WHERE "db" > (CORE * 10) 
GROUP BY "HOST";



SELECT s."symbol", extract(DAY from "DATE") Dia, SUM(CORE) TOTAL_CPU_Usage, MIN(CORE) MIN_CPU_Usage, MAX(CORE) MAX_CPU_Usage 
FROM WEB_STAT w, stock_symbol s 
WHERE 
lower(substr(w."DOMAIN", 0, CASE WHEN strpos(w."DOMAIN", '.') = 0 THEN length(w."DOMAIN")+1 ELSE strpos(w."DOMAIN", '.')END)) 
= lower(substr(s.company, 0, CASE WHEN strpos(s.company, ' ') = 0 THEN length(s.company)+1 ELSE strpos(s.company, ' ')END)) 
GROUP BY s."symbol", extract(DAY from "DATE")
order by 1,2;