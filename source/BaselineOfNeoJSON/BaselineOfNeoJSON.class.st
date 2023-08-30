"
I am BaselineOfNeoJSON, I load the code for the NeoJSON project.
I am a BaselineOf.
"
Class {
	#name : #BaselineOfNeoJSON,
	#superclass : #BaselineOf,
	#category : 'BaselineOfNeoJSON'
}

{ #category : #baselines }
BaselineOfNeoJSON >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'Neo-JSON-Core';
				package: 'Neo-JSON-Extensions' with: [ spec requires: 'Neo-JSON-Core'];
				package: 'Neo-JSON-Tests' with: [ spec requires: #('Neo-JSON-Core' 'Neo-JSON-Extensions') ];
				group: 'default' with: #('core' 'tests');
				group: 'core' with: #('Neo-JSON-Core' 'Neo-JSON-Extensions');
				group: 'tests' with: #('Neo-JSON-Tests') ].
	spec
		for: #pharo
		do: [ spec
				package: 'Neo-JSON-Pharo-Core' with: [ spec requires: #('Neo-JSON-Core') ];
				package: 'Neo-JSON-Pharo-Tests' with: [ spec requires: #('Neo-JSON-Tests') ];
				group: 'core' with: #('Neo-JSON-Core' 'Neo-JSON-Pharo-Core' 'Neo-JSON-Extensions');
				group: 'tests' with: #('Neo-JSON-Tests' 'Neo-JSON-Pharo-Tests')].
]
