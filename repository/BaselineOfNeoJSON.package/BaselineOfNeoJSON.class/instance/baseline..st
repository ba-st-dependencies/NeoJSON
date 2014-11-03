baselines
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        package: 'Neo-JSON-Core';
        package: 'Neo-JSON-Tests' with: [ spec requires: 'Neo-JSON-Core' ];
        group: 'default' with: #('Neo-JSON-Core' 'Neo-JSON-Tests');
        group: 'Core' with: #('Neo-JSON-Core');
        group: 'Tests' with: #('Neo-JSON-Tests') ]