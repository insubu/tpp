SELECT
  s.sid,
  s.username,
  l.opname,
  l.sofar,
  l.totalwork,
  l.units,
  l.time_remaining,
  l.elapsed_seconds
FROM
  v$session s
JOIN
  v$session_longops l ON s.sid = l.sid AND s.serial# = l.serial#
WHERE
  l.time_remaining > 0;

BEGIN
  DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'STORAGE', false);
  DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'TABLESPACE', false);
  DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', false);
END;

