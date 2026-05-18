with
    empresa as (select * from {{ ref("int_empresa") }}),

    categoria as (select * from {{ ref("int_categoria_empresa") }}),

    pais as (select * from {{ ref("int_pais") }}),

    final (
        select
            e.id_empresa,
            e.codigo_empresa,
            e.nombre,
            e.id_pais,
            p.nombre as pais,
            e.id_categoria_empresa,
            c.nombre as categoria,
            e.web,
            e.email,
            e.dbt_valid_from as valido_desde,
            e.dbt_valid_to as valido_hasta,
            (e.dbt_valid_to is null)::boolean as es_vigente

        from empresa e
        left join pais p on e.id_pais = p.id_pais
        left join categoria c on e.id_categoria_empresa = c.id_categoria_empresa
    )

select *
from final
