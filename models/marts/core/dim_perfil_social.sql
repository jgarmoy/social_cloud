with
    perfil as (select * from {{ ref("snp_perfil_social") }}),

    empresa as (select * from {{ ref("int_empresa") }}),

    red_social as (select * from {{ ref("int_red_social") }}),

    joined as (
        select
            p.id_perfil_social,
            p.codigo_perfil_social,
            p.id_empresa,
            p.id_red_social,
            p.nombre_usuario,
            p.fecha_creacion,
            p.activo,
            r.nombre as red_social,
            e.nombre as empresa_nombre,
            e.codigo_empresa,
            e.pais as empresa_pais,
            e.categoria as empresa_categoria,
            p.dbt_valid_from as valido_desde,
            p.dbt_valid_to as valido_hasta,
            (p.dbt_valid_to is null)::boolean as es_vigente

        from perfil p
        left join red_social r on p.id_red_social = r.id_red_social
        left join empresa e on p.id_empresa = e.id_empresa
    )

select *
from joined
