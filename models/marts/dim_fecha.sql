{{ config(pre_hook="alter session set timezone = 'Europe/Madrid'") }}

with
    fechas as (

        {{
            dbt_utils.date_spine(
                datepart="day",
                start_date="cast('2024-01-01' as date)",
                end_date="cast('2025-12-31' as date)",
            )
        }}

    ),

    final as (

        select
            year(date_day) * 10000 + month(date_day) * 100 + day(date_day) as id_fecha,
            date_day as fecha,
            year(date_day) as anio,
            month(date_day) as mes,
            case
                monthname(date_day)
                when 'Jan'
                then 'Enero'
                when 'Feb'
                then 'Febrero'
                when 'Mar'
                then 'Marzo'
                when 'Apr'
                then 'Abril'
                when 'May'
                then 'Mayo'
                when 'Jun'
                then 'Junio'
                when 'Jul'
                then 'Julio'
                when 'Aug'
                then 'Agosto'
                when 'Sep'
                then 'Septiembre'
                when 'Oct'
                then 'Octubre'
                when 'Nov'
                then 'Noviembre'
                when 'Dec'
                then 'Diciembre'
            end as desc_mes,
            day(date_day) as dia,
            dayofweek(date_day) as dia_semana,
            case
                dayname(date_day)
                when 'Mon'
                then 'Lunes'
                when 'Tue'
                then 'Martes'
                when 'Wed'
                then 'Miercoles'
                when 'Thu'
                then 'Jueves'
                when 'Fri'
                then 'Viernes'
                when 'Sat'
                then 'Sábado'
                when 'Sun'
                then 'Domingo'
            end as desc_dia_semana,
            quarter(date_day) as trimestre,
            case
                when dayofweek(date_day) in (0, 6) then true else false
            end as es_fin_de_semana

        from fechas

    )

select *
from final
