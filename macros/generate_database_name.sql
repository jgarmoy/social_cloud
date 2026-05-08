-- Esta macro no es necesaria pero es una buena práctica

-- ¡Esta macro es opcional! El +database funciona sin ella pero es buena práctica tenerla.

{% macro generate_database_name(
    custom_database_name, node
) -%}

    {%- if custom_database_name is not none -%}
        {{ custom_database_name | trim }}
    {%- else -%}
        {{ target.database | trim }}
    {%- endif -%}

{% endmacro %}