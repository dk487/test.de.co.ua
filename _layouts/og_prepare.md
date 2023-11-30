{%- if page.opegraph_generator -%}
---
permalink: '{{ page.date | date: '%Y-%m-%d' }}-{{ page.slug }}.svg'
{%- if page.opegraph_generator.template %}
layout: og_{{ page.opegraph_generator.template }}
{%- else %}
layout: og_default
{%- endif %}

{%- if page.opegraph_generator.label_row1 %}
label_row1: {{ page.opegraph_generator.label_row1 }}
{%- else %}
label_row1: {{ page.title }}
{%- endif %}

{%- if page.opegraph_generator.label_row2 %}
label_row2: {{ page.opegraph_generator.label_row2 }}
{%- endif %}

{%- if page.opegraph_generator.label_row3 %}
label_row3: {{ page.opegraph_generator.label_row3 }}
{%- endif %}

{%- if page.opegraph_generator.key_color %}
key_color: {{ page.opegraph_generator.key_color }}
{%- endif %}
---
{% else -%}
---
permalink: '_ignore/{{ page.date | date: '%Y-%m-%d' }}-{{ page.slug }}'
layout:
---
{%- endif %}
