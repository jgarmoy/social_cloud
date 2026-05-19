with
    post as (select * from {{ ref("int_post") }}),
    interaccion as (select * from {{ ref("int_interaccion") }}),
    empresa as (select * from {{ ref("int_empresa") }}),

    final as (
        select
            i.id_interaccion,
            p.id_post,
            i.id_tipo_interaccion,
            p.id_empresa,
            p.id_perfil_social,
            p.id_tipo_contenido,
            p.id_fuente_ingesta,
            year(p.fecha_publicacion) * 10000
            + month(p.fecha_publicacion) * 100
            + day(p.fecha_publicacion) as id_fecha,

            e.id_pais as id_pais_empresa,
            e.id_categoria_empresa,

            p.patrocinado,
            p.es_campania,
            p.visualizaciones,
            p.alcance,
            p.impresiones,
            p.engagement_total,
            i.total_interaccion,
            case
                when p.alcance > 0 then round(p.engagement_total / p.alcance * 100, 4)
            end as engagement_rate_pct

        from post p
        inner join interaccion i on p.id_post = i.id_post
        left join empresa e on p.id_empresa = e.id_empresa
    )

select *
from final
