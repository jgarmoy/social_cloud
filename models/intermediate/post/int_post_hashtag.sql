with
    source as (select * from {{ ref("int_hashtag_post_separar") }}),

    generar_surrogate_key as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["post_id"]) }} as id_post,
            {{ dbt_utils.generate_surrogate_key(["hashtag"]) }} as id_hashtag
        from source
    )

select *
from generar_surrogate_key
