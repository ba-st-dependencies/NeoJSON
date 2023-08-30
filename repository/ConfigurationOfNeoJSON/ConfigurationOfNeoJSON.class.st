"
I am ConfigurationOfNeoJSON, a Metacello configuration for NeoJSON.

NeoJSON is a flexible and efficient reader and writer for JSON.
"
Class {
	#name : #ConfigurationOfNeoJSON,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : 'ConfigurationOfNeoJSON'
}

{ #category : #'development support' }
ConfigurationOfNeoJSON class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfNeoJSON class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfNeoJSON class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfNeoJSON class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfNeoJSON class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfNeoJSON class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfNeoJSON class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfNeoJSON class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfNeoJSON class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfNeoJSON class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfNeoJSON >> baseline1: spec [
	<version: '1-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			repository: 'http://mc.stfx.eu/Neo';
			package: 'Neo-JSON-Core';
			package: 'Neo-JSON-Tests' with: [ spec requires: 'Neo-JSON-Core' ];
			group: 'default' with: #('Neo-JSON-Core' 'Neo-JSON-Tests');
			group: 'Core' with: #('Neo-JSON-Core');
			group: 'Tests' with: #('Neo-JSON-Tests') ]
]

{ #category : #baselines }
ConfigurationOfNeoJSON >> baseline2: spec [
	<version: '2-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				repository: 'http://mc.stfx.eu/Neo';
				package: 'Neo-JSON-Core';
				package: 'Neo-JSON-Tests' with: [ spec requires: 'Neo-JSON-Core' ];
				group: 'default' with: #('Neo-JSON-Core' 'Neo-JSON-Tests');
				group: 'Core' with: #('Neo-JSON-Core');
				group: 'Tests' with: #('Neo-JSON-Tests') ].
	spec
		for: #gemstone
		do: [ 
			spec
				baseline: 'NeoJSON' with: [ spec repository: 'github://GsDevKit/NeoJSON:master/repository' ];
				import: 'NeoJSON' ]
]

{ #category : #accessing }
ConfigurationOfNeoJSON >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfNeoJSON >> stable: spec [
	<symbolicVersion: #'stable'>
	
	spec for: #common version: '9'.
	spec for: #gemstone version: '10'.
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version10: spec [
	<version: '10' imports: #('2-baseline')>
	spec
		for: #common
		do: [ 
			spec
				blessing: #release;
				package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.27';
				package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.24' ].
	spec
		for: #'gs3.x'
		do: [ 
			spec import: 'NeoJSON'.
			spec baseline: 'NeoJSON' with: [ spec repository: 'github://GsDevKit/NeoJSON:master/repository' ] ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version1: spec [
	<version: '1' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.17';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.15' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version2: spec [
	<version: '2' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.19';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.16' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version3: spec [
	<version: '3' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.20';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.16' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version4: spec [
	<version: '4' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.23';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.18' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version5: spec [
	<version: '5' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.24';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.19' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version6: spec [
	<version: '6' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.24';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.20' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version7: spec [
	<version: '7' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.24';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.21' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version8: spec [
	<version: '8' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.24';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.22' ]
]

{ #category : #versions }
ConfigurationOfNeoJSON >> version9: spec [
	<version: '9' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Neo-JSON-Core' with: 'Neo-JSON-Core-SvenVanCaekenberghe.27';
			package: 'Neo-JSON-Tests' with: 'Neo-JSON-Tests-SvenVanCaekenberghe.24' ]
]
