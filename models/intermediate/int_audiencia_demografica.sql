with source as (
    select * from {{ ref('stg_social_cloud_schema__raw_audiencia_demografica') }}
),
renamed as (
    select 
        empresa_id,
        perfil_id, 
        coalesce(tk_handle, ig_username, yt_handle, 'N/A') as username,
        coalesce(tk_platform, ig_platform, network, 'N/A') as plataforma,
        coalesce(snapshot_date, report_date, period) as fecha_snapshot,
        coalesce(gender_segment, audience_gender, genero, 'N/A') as genero,
        coalesce(age_segment, audience_age, edad, 'N/A') as edad_segmento,
        coalesce(country, audience_country, pais_audiencia, 'N/A') as pais,
        coalesce(audience_share_pct, pct_audience, porcentaje) as porcentaje_audiencia,
        coalesce(seg_followers, follower_count_seg, n_seguidores_seg) as seguidores,
        created_at,
        updated_at,
        _line,
        _fivetran_synced
    from source
)

select * from renamed