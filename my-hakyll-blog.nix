{ mkDerivation
, base
, blaze-html
, filepath
, hakyll
, hashable
, lib
, time
, unordered-containers
}:
mkDerivation {
  pname = "my-hakyll-blog";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base
    blaze-html
    filepath
    hakyll
    hashable
    time
    unordered-containers
  ];
  license = lib.licenses.bsd3;
}
