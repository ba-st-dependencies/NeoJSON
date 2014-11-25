testing
testAsciiOnlyStrings
  | objects |
  objects := {'foo'.
  'Foo BAR'.
  ''.
  '	\\'''.
  'élève en Français'.
  'Я можу їсти скло, і воно мені не зашкодить.'.
  '𣎏'}.
  self assert: (self writeReadAsciiOnly: objects) equals: objects