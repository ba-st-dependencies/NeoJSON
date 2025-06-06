"
I am BaselineOfNeoJSON, I load the code for the NeoJSON project.
I am a BaselineOf.
"
Class {
	#name : 'BaselineOfNeoJSON',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfNeoJSON',
	#package : 'BaselineOfNeoJSON'
}

{ #category : 'baselines' }
BaselineOfNeoJSON >> baseline: spec [

  <baseline>
  spec for: #pharo do: [
      self
        setUpDependencies: spec;
        setUpDeploymentPackages: spec;
        setUpTestPackages: spec.

      spec
        group: 'Development' with: #( 'Tests' );
        group: 'CI' with: 'Tests';
        group: 'default' with: 'Development'
    ]
]

{ #category : 'accessing' }
BaselineOfNeoJSON >> projectClass [

  ^ MetacelloCypressBaselineProject
]

{ #category : 'baselines' }
BaselineOfNeoJSON >> setUpDependencies: spec [

  spec
    baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v8' ];
    project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ]
]

{ #category : 'baselines' }
BaselineOfNeoJSON >> setUpDeploymentPackages: spec [

  spec
    package: 'Neo-JSON-Core' with: [ spec requires: 'Buoy-Deployment' ];
    group: 'Deployment' with: 'Neo-JSON-Core';
    package: 'Neo-JSON-Pharo-Core' with: [ spec requires: 'Neo-JSON-Core' ];
    group: 'Deployment' with: 'Neo-JSON-Pharo-Core';
    package: 'Neo-JSON-Extensions' with: [ spec requires: 'Neo-JSON-Core' ];
    group: 'Deployment' with: 'Neo-JSON-Extensions';
    package: 'Neo-JSON-Pharo-Base-Extensions' with: [ spec requires: 'Neo-JSON-Core' ];
    group: 'Deployment' with: 'Neo-JSON-Pharo-Base-Extensions'
]

{ #category : 'baselines' }
BaselineOfNeoJSON >> setUpTestPackages: spec [

  spec
    package: 'Neo-JSON-Tests' with: [
        spec requires:
            #( 'Neo-JSON-Core' 'Neo-JSON-Pharo-Core' 'Neo-JSON-Extensions' 'Neo-JSON-Pharo-Base-Extensions' )
      ];
    group: 'Tests' with: 'Neo-JSON-Tests'
]
