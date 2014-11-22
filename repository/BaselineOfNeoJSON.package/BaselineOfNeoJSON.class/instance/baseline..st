baselines
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        baseline: 'GLASS1'
          with: [ 
              spec
                loads: #('GsSqueakCommon');
                repository: 'github://glassdb/glass:master/repository' ];
        yourself.
      spec
        package: 'Neo-JSON-Core' with: [ spec requires: 'GLASS1' ];
        package: 'Neo-JSON-Tests' with: [ spec requires: 'Neo-JSON-Core' ];
        yourself.
      spec
        group: 'default' with: #('Neo-JSON-Core' 'Neo-JSON-Tests');
        group: 'Core' with: #('Neo-JSON-Core');
        group: 'Tests' with: #('Neo-JSON-Tests');
        yourself ]