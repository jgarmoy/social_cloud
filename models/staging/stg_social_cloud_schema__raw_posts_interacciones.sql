with source as (
    select * from {{ source('social_cloud_schema', 'raw_posts_interacciones') }}
),
renamed as (
    select
        trim(post_id) as post_id,
        raw_json_id,
        case 
            when username ilike '@%' then substr(trim(username), 2)
            else username
        end as username,
        trim(empresa_id) as empresa_id,
        case
            when regexp_like(trim(plataforma), '^(instagram|ig|insta)$', 'i') then 'Instagram'
            when regexp_like(trim(plataforma), '^(tiktok|tk|tik tok)$', 'i') then 'Tiktok'
            when regexp_like(trim(plataforma), '^(youtube|yt|you tube)$', 'i') then 'Youtube'
            else 'Desconocido'
        end as plataforma,
        fecha_publicacion,
        initcap(trim(tipo_contenido)) as tipo_contenido,
        descripcion,
        patrocinado,
        es_campana_bf as es_campania_bf,
        hashtags,
        visualizaciones as visualizaciones_post,
        alcance as alcance_post,
        impresiones as impresiones_post,
        initcap(trim(tipo_interaccion)) as tipo_interaccion,
        cantidad_interaccion,
        engagement_total,
        lower(source_api) as source_api,
        created_at,
        updated_at,
        _line,
        _fivetran_synced
    from source
)
select * from renamed