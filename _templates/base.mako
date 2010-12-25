<?xml version="1.0" encoding="utf-8"?>
<%def name="filter(chain)">
  ${bf.filter.run_chain(chain, capture(caller.body))}
</%def>

${next.body()}
