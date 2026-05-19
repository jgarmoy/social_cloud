{{
    config(
        materialized="incremental",
        incremental_strategy="append",
        on_schema_change="append_new_columns",
    )
}}

with
    source_posts as (
        select *
        from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
        {% if is_incremental() %}
            where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})
        {% endif %}
    ),
    source_perfil_social as (select * from {{ ref("snp_perfil_social") }}),

    renombrar as (
        select
            {{ dbt_utils.generate_surrogate_key(["p.post_id"]) }} as id_post,
            p.post_id as codigo_post,
            p.raw_json_id,
            ps.id_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["p.tipo_contenido"]) }}
            as id_tipo_contenido,
            {{ dbt_utils.generate_surrogate_key(["p.source_api"]) }}
            as id_fuente_ingesta,
            p.es_campania_bf as es_campania,
            p.fecha_publicacion,
            p.descripcion_en,
            p.patrocinado,
            p.visualizaciones_post as visualizaciones,
            p.alcance_post as alcance,
            p.impresiones_post as impresiones,
            p.engagement_total,
            p._fivetran_synced
        from source_posts p
        left join
            source_perfil_social ps
            on p.username = ps.nombre_usuario
            and p.fecha_publicacion >= ps.dbt_valid_from
            and (ps.dbt_valid_to is null or p.fecha_publicacion < ps.dbt_valid_to)
        qualify
            row_number() over (partition by p.post_id order by p.updated_at desc) = 1
    )

select *
from renombrar
