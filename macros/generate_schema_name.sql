-- Macro para sobreescibir el default schema y poder usar el +schema. Así conseguimos que solo devuelva staging o marts sin el target.schema

{% macro generate_schema_name(
    custom_schema_name, node
) -%}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is not none -%}
        {{ custom_schema_name | trim}}
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}

{%- endmacro -%}