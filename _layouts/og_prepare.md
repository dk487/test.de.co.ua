{%- if page.opengraph_generator -%}
---
permalink: '{{ page.date | date: '%Y-%m-%d' }}-{{ page.slug }}.svg'
{%- if page.opengraph_generator.template %}
layout: og_{{ page.opengraph_generator.template }}
{%- else %}
layout: og_default
{%- endif %}

{%- if page.opengraph_generator.label_row1 %}
label_row1: {{ page.opengraph_generator.label_row1 }}
{%- else %}
label_row1: {{ page.title }}
{%- endif %}

{%- if page.opengraph_generator.label_row2 %}
label_row2: {{ page.opengraph_generator.label_row2 }}
{%- endif %}

{%- if page.opengraph_generator.label_row3 %}
label_row3: {{ page.opengraph_generator.label_row3 }}
{%- endif %}

{%- if page.opengraph_generator.key_color %}
key_color: {{ page.opengraph_generator.key_color }}
{%- endif %}
---
{% else -%}
---
permalink: '_ignore/{{ page.date | date: '%Y-%m-%d' }}-{{ page.slug }}'
layout:
---
{%- endif %}
