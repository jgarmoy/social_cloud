with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),
    renamed as (
        select
            {{ dbt_utils.generate_surrogate_key(["empresa_nombre"]) }} as id_empresa,  -- No hay nulos
            empresa_id as codigo_empresa,
            empresa_nombre as nombre,
            {{ dbt_utils.generate_surrogate_key(["empresa_pais"]) }} as id_pais,
            {{ dbt_utils.generate_surrogate_key(["empresa_categoria"]) }}
            as id_categoria_empresa,
            empresa_web as web,
            empresa_email as email
        from source
        qualify
            row_number() over (
                partition by empresa_id order by empresa_web, empresa_email
            )
            = 1  -- Como no le doy mucha importancia a la web y al email me quedo con los ambos sean no nulos y sino uno de los dos aunque primero va la web, no veas lo que me ha costado. Quería y he conseguido particionar por empresa_id y así hacer que me de el resultado a ser posible que tenga ambas opciones
    )
    
select *
from renamed
