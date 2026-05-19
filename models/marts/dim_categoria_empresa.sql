with source as (select * from {{ ref("int_categoria_empresa") }}) select * from source
