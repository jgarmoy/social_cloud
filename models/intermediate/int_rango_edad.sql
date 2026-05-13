with source as (
    select * from {{ source('social_cloud_schema', 'raw_audiencia_demografica') }}
),
unir_rango_edad as (
    select distinct
        age_segment as rango_edad
    from source
    union
    select distinct
        audience_age as rango_edad
    from source
    union
    select distinct
        edad as rango_edad
    from source
),
min_max_grk_rango_edad as (
    select 
        {{ dbt_utils.generate_surrogate_key(["lower(coalesce(rango_edad, 'Desconocido'))"]) }} as id_rango_edad,
        coalesce(rango_edad, 'desconocido') as rango_edad,
        case
            when rango_edad ilike '%-%' then cast(split(rango_edad, '-')[0] as integer)
            when rango_edad ilike '%+' then cast(split(rango_edad, '+')[0] as integer)
            else null
        end as edad_min,
        case
            when rango_edad ilike '%-%' then cast(split(rango_edad, '-')[1] as integer)
            when rango_edad ilike '%+' then null
            else null
        end as edad_max,

    from unir_rango_edad
)
select * from min_max_grk_rango_edad