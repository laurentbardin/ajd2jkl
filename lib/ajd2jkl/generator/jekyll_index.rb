module Ajd2jkl
    module Generator
        module Jekyll
            def self.layout
                idx =<<EOF
---
title: API Docs
---
{% assign sorted_collections = site.collections | sort: "position" %}
{% for collection in sorted_collections %}
	{% assign sorted_docs = collection.docs | sort: "position" %}
	{% for doc in sorted_docs %}
		<section class="doc-content">
			<section class="left-docs">
				<h3>
					<a id="{{ doc.id | replace: '/', '' | replace: '.', '' }}">
						{{ doc.title }}
						{% if doc.type %}
							<span class="endpoint {{ doc.type }}"></span>
						{% endif %}
					</a>
				</h3>
				{% if doc.description %}
					<p class="description">{{doc.description}}</p>
				{% endif %}

				{{ doc.content | replace: "<dl>", "<h6>Parameters</h6><dl>" }}
			</section>

			{% if doc.right_code %}
				<section class="right-code">
					{{ doc.right_code | markdownify }}
				</section>
			{% endif %}
		</section>
	{% endfor %}
{% endfor %}
EOF
                idx
            end
        end
    end
end
