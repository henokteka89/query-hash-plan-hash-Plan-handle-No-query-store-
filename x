DECLARE @ProcName SYSNAME = 'YourProcedureName';

SELECT
    OBJECT_NAME(st.objectid, st.dbid) AS proc_name,
    qs.plan_handle,
    qs.execution_count,
    qs.total_worker_time / qs.execution_count AS avg_cpu_time_microsec,
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time_microsec,
    cp.usecounts AS plan_use_count,
    cp.objtype,
    cp.cacheobjtype,
    st.text AS query_text
FROM
    sys.dm_exec_query_stats AS qs
JOIN
    sys.dm_exec_cached_plans AS cp
    ON qs.plan_handle = cp.plan_handle
CROSS APPLY
    sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE
    OBJECT_NAME(st.objectid, st.dbid) = @ProcName
ORDER BY
    avg_cpu_time_microsec DESC;


DECLARE @ProcName SYSNAME = 'YourProcedureName';

SELECT
    OBJECT_NAME(st.objectid, st.dbid) AS proc_name,
    qs.plan_handle,
    qs.execution_count,
    qs.total_worker_time / NULLIF(qs.execution_count, 0) AS avg_cpu_time_microsec,
    qs.total_elapsed_time / NULLIF(qs.execution_count, 0) AS avg_elapsed_time_microsec,
    cp.usecounts,
    st.text
FROM
    sys.dm_exec_cached_plans cp
JOIN
    sys.dm_exec_query_stats qs
    ON cp.plan_handle = qs.plan_handle
CROSS APPLY
    sys.dm_exec_sql_text(cp.plan_handle) st
WHERE
    OBJECT_NAME(st.objectid, st.dbid) = @ProcName
ORDER BY
    avg_cpu_time_microsec DESC;
