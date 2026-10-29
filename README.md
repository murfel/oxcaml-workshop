# OxCaml workshop

## Run it on GitHub Codespaces (easiest)

Codespaces runs the container on GitHub's servers and gives you VS Code in
your browser. Nothing to install locally.

1. On the repository page, click **Code → Codespaces → Create codespace on
   main**.
2. Wait a minute or two.
3. Open the terminal (**Terminal → New Terminal**) and run:

   ```bash
   $ ocaml --version
   ```
4. Install the missing dependencies

    ```bash
    $ opam install --yes parallel portable_lockfree_htbl
    ```

5. Build this project:

   ```bash
   $ cd exercises
   $ dune build
   ```

### When you're done

Personal GitHub accounts include 120 core-hours of Codespaces per month for
free, which is 60 hours on the default 2-core machine, plus 15 GB of storage.
That's plenty for trying OxCaml. A stopped Codespace doesn't use compute
hours, but it does keep using storage, so delete it once you're finished:

```bash
gh codespace delete
```

or on the repository page, **Code → Codespaces → ⋯ → Delete**. You can
always create a fresh one later; it takes a minute or two.

See [About billing for GitHub Codespaces](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)
for the details.
