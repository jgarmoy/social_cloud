with source as (select * from {{ ref("int_pais") }}) select id_pais, nombre from source
