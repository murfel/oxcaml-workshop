# OxCaml workshop
Data-race freedom with OxCaml. Contention, portability, atomics, fork-join, capsules and mutexes.


[Slides](https://htmlpreview.github.io/?https://github.com/murfel/oxcaml-workshop/blob/main/slides/readme.html)

[Exercises](https://github.com/murfel/oxcaml-workshop/tree/main/exercises/bin)

[Solutions branch](https://github.com/murfel/oxcaml-workshop/tree/solutions/exercises/bin) ([PR view](https://github.com/murfel/oxcaml-workshop/pull/1))

Please note this workshop was prepared to be delivered in-person. Self-paced learners are welcome, but expect to have to look things up. In particular, exercises seem to be a bit too steep. Complain in issues if anything.

## Run it on GitHub Codespaces

Codespaces runs the container on GitHub's servers and gives you VS Code in
your browser. Nothing to install locally.

0. Go to GitHub's [**Settings → Codespaces**](https://github.com/settings/codespaces), scroll down, and set **Default idle timeout** to 240 minutes (4 hours).
1. On the repository page, scroll up, click **Code** (the green button on the top right) **→ Codespaces → Create codespace on main**.
2. Wait ~10 minutes.
3. In the opened browser VS Code, open the terminal (click `+` in the top right of the bottom central pane) and build the project:

   ```bash
   cd exercises
   dune build
   ```

After you are done with the exercises, export your progress to a fork. Only do it **after** the workshop, as your fork will be rebuilding the image for ~1 hour.

**Code → Codespaces → ⋯ → Export changes to a fork**

## Thanks!

Codespaces setup by Sudha ([original](https://github.com/Sudha247/sample-oxcaml-devcontainer))

Capsule access, password, key examples from the [official tutorial](https://oxcaml.org/documentation/parallelism/capsules/)