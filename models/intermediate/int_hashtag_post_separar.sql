with
    source as (
        select *
        from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
        where hashtags is not null and trim(hashtags) != ''
    ),

    separado as (
        select
            post_id,
            plataforma,
            lower(
                trim(
                    case
                        when trim(value) ilike '#%'
                        then substr(trim(value), 2)
                        else trim(value)
                    end
                )
            ) as hashtag
        from source, lateral split_to_table(source.hashtags, ' ')
    ),

    -- Elimino los valores vacios que puede crear el split_to_table
    filtrado as (select * from separado where hashtag is not null and hashtag != '')

select *
from filtrado
