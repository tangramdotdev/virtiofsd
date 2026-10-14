# Contributing to virtiofsd

virtiofsd is an open source project licensed under the [Apache v2 License](https://opensource.org/licenses/Apache-2.0) and the [BSD 3 Clause](https://opensource.org/licenses/BSD-3-Clause) license.

## Coding Style

We follow the [Rust Style](https://github.com/rust-dev-tools/fmt-rfcs/blob/master/guide/guide.md)
convention and enforce it through the Continuous Integration (CI) process calling into `rustfmt`
for each submitted Pull Request (PR).

## Certificate of Origin

In order to get a clear contribution chain of trust we use the [signed-off-by language](https://01.org/community/signed-process)
used by the Linux kernel project.

## Patch format

Beside the signed-off-by footer, we expect each patch to comply with the following format:

```
Change summary

More detailed explanation of your changes: Why and how.
Wrap it to 72 characters.
See http://chris.beams.io/posts/git-commit/
for some more good pieces of advice.

Signed-off-by: <contributor@foo.com>
```

For example:

```
Implement support for optional sandboxing
    
Implement support for setting up a sandbox for running the
service. The technique for this has been borrowed from virtiofsd, and
consists on switching to new PID, mount and network namespaces, and
then switching root to the directory to be shared.
   
Future patches will implement additional hardening features like
dropping capabilities and seccomp filters.
  
Signed-off-by: Sergio Lopez <slp@redhat.com>
```

## Commit integrity

Every commit must leave the tree in a valid, working state. Each commit must:

1. Compile successfully (`cargo build`)
2. Pass tests (`cargo test`)
3. Not break existing functionality

This ensures tools like `git bisect` remain useful: a binary search across commit
history only works when every intermediate commit is a buildable, functional state of
the project.

### Practical implications

- Don't add a reference to a module in one commit and the module itself in the next
- Don't split a refactor so one commit removes an interface while the next adds its
  replacement
- Code motion and semantic changes belong in separate commits, but each must stand
  alone

## Splitting changes

Split your work into a series of logical, self-contained commits. Each commit
should do one thing and do it completely:

- A commit message containing "Also, ..." is a good sign the commit should be split
- Keep **code motion** (moving code without changing it) in one commit and
  **semantic changes** in another
- Keep **formatting/style fixes** separate from functional changes
- Don't include unrelated changes (whitespace fixes in code you're not otherwise
  touching)

## Merge requests

virtiofsd uses the "fork-and-merge" development model. Follow these steps if
you want to merge your changes to `virtiofsd`:

1. Fork the [virtiofsd](https://gitlab.com/virtio-fs/virtiofsd) project
   into your GitLab organization.
2. Within your fork, create a branch for your contribution.
3. [Create a merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
   against the master branch of the virtiofsd repository.
4. Once the merge request is approved, one of the maintainers will merge it.

### No squash merges

We do **not** use squash merges. Each commit in your merge request is preserved
individually in the project history. This means every commit you submit matters.
Write each one as a clean, self-contained change with a proper commit message and
Signed-off-by, because that is exactly what will land in the repository.

## Issue tracking

If you have a problem, please let us know. We recommend using
[gitlab issues](https://gitlab.com/virtio-fs/virtiofsd/-/issues/new) for formally
reporting and documenting them.

You can also contact us via email through the [virtio-fs mailing list](https://www.redhat.com/mailman/listinfo/virtio-fs).

## Closing issues

You can either close issues manually by adding the fixing commit SHA1 to the issue
comments or by adding the `Fixes` keyword to your commit message.

After the corresponding MR is merged, GitLab will automatically close that issue when parsing the
[commit message](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically).
