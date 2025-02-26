{#
    This macro returns quarter
#}

{% macro get_quarter(month) -%}

    case 
        when {{ dbt.safe_cast(month, api.Column.translate_type("integer")) }}   between 1 and 3 then 'Q1'
        when {{ dbt.safe_cast(month, api.Column.translate_type("integer")) }}   between 4 and 6 then 'Q2'
        when {{ dbt.safe_cast(month, api.Column.translate_type("integer")) }}   between 7 and 9 then 'Q3'
        when {{ dbt.safe_cast(month, api.Column.translate_type("integer")) }}   between 10 and 12 then 'Q4'
    end

{%- endmacro %}