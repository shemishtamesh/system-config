inputs:
let
  hostnames = import ./hosts;
  recursiveMerge =
    attrList:
    with inputs.nixpkgs.lib;
    let
      merge =
        attrPath:
        zipAttrsWith (
          name: values:
          if tail values == [ ] then
            head values
          else if all isList values then
            unique (concatLists values)
          else if all isAttrs values then
            merge (attrPath ++ [ name ]) values
          else
            last values
        );
    in
    merge [ ] attrList;
in
builtins.foldl' (
  accumulator: module:
  recursiveMerge [
    accumulator
    ((import module) (import ./shared/profile_makers.nix inputs))
  ]
) { } (map (name: ./hosts/${name}) hostnames)
// import ./shared/flake-attributes.nix inputs
