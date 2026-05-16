with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_audiencia_demografica") }}
    ),

    normalizado as (
        select
            empresa_id,
            perfil_id,
            coalesce(tk_handle, ig_username, yt_handle) as username,
            case
                when tk_handle is not null
                then 'Tiktok'
                when ig_username is not null
                then 'Instagram'
                when yt_handle is not null
                then 'Youtube'
            end as plataforma,
            coalesce(snapshot_date, report_date, period) as fecha_snapshot,
            coalesce(gender_segment, audience_gender, genero) as genero,
            coalesce(age_segment, audience_age, edad) as edad_segmento,
            coalesce(country, audience_country, pais_audiencia) as pais,
            coalesce(
                audience_share_pct, pct_audience, porcentaje
            ) as porcentaje_audiencia,
            coalesce(seg_followers, follower_count_seg, n_seguidores_seg) as seguidores,
            created_at,
            updated_at,
            _line,
            _fivetran_synced
        from source
    ),

    filtrado as (
        select *
        from normalizado
        where
            username is not null
            and plataforma is not null
            and fecha_snapshot is not null
    )

select *
from filtrado
