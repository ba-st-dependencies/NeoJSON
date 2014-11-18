"Load and run tests to be performed by TravisCI"
| gitPath |
Transcript cr; show: 'travis---->travisCI.st'.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.
(Smalltalk at: #GsUpgrader) upgradeGrease.

GsDeployer deploy: [
  "Load NeoJSON... "
  Metacello new
    baseline: 'NeoJSON';
    repository: 'filetree://', gitPath, '/NeoJSON/repository';
    onLock: [:ex | ex honor ];
    load: #('default')
].

"Run the  NeoJSON tests"
TravisCIHarness
  value: #( 'BaselineOfNeoJSON' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.
