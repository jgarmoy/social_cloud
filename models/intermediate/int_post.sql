-- Tenía duda sobre si poner merge o delete / insert, aunque al final me he decantado por append porque no van a entrar datos repetidos y he priorizado 
/*{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'append',
        on_schema_change = 'append_new_columns'
    )
}}
traducir_desc as (
    select 
        id_post,
        codigo_post,
        raw_json_id,
        id_perfil_social,
        id_tipo_contenido,
        id_fuente_ingesta,
        es_campania,
        fecha_publicacion,
        ai_translate(descripcion_en, '', 'es') as descripcion,
        patrocinado,
        visualizaciones,
        alcance,
        impresiones,
        engagement_total,
        created_at,
        updated_at,
        _fivetran_synced

    from renamed 
)*/

with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
        {% if is_incremental() %}
            where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})
        {% endif %}
    ),
    renamed as (
        select
            {{ dbt_utils.generate_surrogate_key(["post_id"]) }}
            as id_post,
            post_id as codigo_post,
            raw_json_id,
            {{ dbt_utils.generate_surrogate_key(["username"]) }} as id_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["tipo_contenido"]) }}
            as id_tipo_contenido,
            {{ dbt_utils.generate_surrogate_key(["source_api"]) }} as id_fuente_ingesta,
            es_campania_bf as es_campania,
            fecha_publicacion,
            descripcion_en,
            patrocinado,
            visualizaciones_post as visualizaciones,
            alcance_post as alcance,
            impresiones_post as impresiones,
            engagement_total,
            created_at,
            updated_at,
            _fivetran_synced
        from source
        qualify row_number() over (partition by post_id order by updated_at desc) = 1
    )
    
select 
   *
from renamed
