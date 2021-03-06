SELECT att.attname as name, att.attnum as OID, format_type(ty.oid,NULL) AS datatype
FROM pg_attribute att
    JOIN pg_type ty ON ty.oid=atttypid
    JOIN pg_namespace tn ON tn.oid=ty.typnamespace
    JOIN pg_class cl ON cl.oid=att.attrelid
    JOIN pg_namespace na ON na.oid=cl.relnamespace
    LEFT OUTER JOIN pg_type et ON et.oid=ty.typelem
    LEFT OUTER JOIN pg_attrdef def ON adrelid=att.attrelid AND adnum=att.attnum
    LEFT OUTER JOIN (pg_depend JOIN pg_class cs ON objid=cs.oid AND cs.relkind='S') ON refobjid=att.attrelid AND refobjsubid=att.attnum
    LEFT OUTER JOIN pg_namespace ns ON ns.oid=cs.relnamespace
    LEFT OUTER JOIN pg_index pi ON pi.indrelid=att.attrelid AND indisprimary
WHERE att.attrelid = {{tid}}::oid
{### To show system objects ###}
{% if not show_sys_objects %}
    AND att.attnum > 0
{% endif %}
    AND att.attisdropped IS FALSE
    ORDER BY att.attnum
