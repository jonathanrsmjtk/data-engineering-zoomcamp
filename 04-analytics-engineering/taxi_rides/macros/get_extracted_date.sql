{#
    This macro returns extracted date
#}

{% macro get_extracted_date(datetime, time_unit) -%}
{%- if time_unit == 'month' -%} extract(month from {{ dbt.safe_cast(datetime, api.Column.translate_type("timestamp")) }}  ) 
{%- elif time_unit == 'day' -%} extract(day from {{ dbt.safe_cast(datetime, api.Column.translate_type("timestamp")) }}  ) 
{%- elif time_unit == 'year' -%} extract(year from {{ dbt.safe_cast(datetime, api.Column.translate_type("timestamp")) }}  ) 
{%- endif -%}

{%- endmacro %}