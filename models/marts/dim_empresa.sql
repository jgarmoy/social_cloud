with
    empresa as (select * from {{ ref("int_empresa") }}),

    final as (select id_empresa, codigo_empresa, nombre, web, email from empresa)

select *
from final
