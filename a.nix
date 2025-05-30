{
  a = lib: {
    splitListIntoChunks =
      list: chunkSize:
      lib.lists.flatten (
        lib.lists.imap0
          (i: x: [
            {
              inherit (x) key value;
            }
          ])
          (
            lib.lists.imap0 (
              i: key: {
                key = key;
                value = lib.lists.elemAt list (i * chunkSize / (lib.lists.length list));
              }
            )
          )
      );

    distributeValues =
      monitors: workspaces:
      lib.lists.imap0 (i: key: {
        ${key} = lib.lists.elemAt monitors (i * lib.lists.length monitors / lib.lists.length workspaces);
      }) workspaces;
  };
}
