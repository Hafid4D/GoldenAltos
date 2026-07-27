# QA Module — Karla feedback (post UAT meeting)

Track follow-up work from the test-server session with Karla Dy.

**Strategy:** implement and validate **locally first**; **test server update + Karla notification** is the **last step** (once all fixes are done).

**Last updated:** 2026-july-27 — **D**, **B**, and **A** done locally.

---

## Local dev — remaining order

- [x] **D** — Rename "Specs Control" to "Document Control" *(entry label: verify "Document Control" vs current "Documents Control")*
- [x] **B** — CAR Team Members: Staff list picker + checkbox + auto title
- [x] **A** — Make certification date editable when assigning to Staff (backdate) — Actions + date dialog
- [ ] **C** — CAR origin type (product / audit / customer...) + traveler fields disabled if not product-related — **after Karla's email** with checkbox rules
- [ ] **E** — Script or import step for `DocumentCategory` on legacy specs

---

## Final step — deploy test server & inform Karla

Do this **only after** local dev checklist above is complete and smoke-tested.

- [ ] Push / deploy latest build to test server (+ **Synchronize Structure** if catalog changed)
- [ ] Confirm with Omar deployment is on test
- [ ] Set up permanent **QM** profile for Karla on test (if not already)
- [ ] **F** — Verify on test server: CAR category, PO / customer / device fields, Staff cert Actions, Document Control filter, team members picker
- [ ] Notify Karla — ready for UAT; share what changed since last session

---

## Reference — all post-meeting requests

| ID | Task | Priority | Complexity | Status |
| --- | --- | --- | --- | --- |
| A | Certification date editable at Staff assignment (backdate) | High | Medium | Done |
| B | CAR Team members: Staff list + checkbox + auto title | High | Medium | Done |
| C | CAR origin type + traveler disabled when not product-related | High (Karla email) | Medium–High | Blocked on email |
| D | Rename entry to Document Control | Low | Trivial | Done *(label check)* |
| E | Categorize existing Specs (`UUID_DocumentCategory`) | Medium | Data / admin script | Local dev |
| F | Verify test server deployment | Blocking UAT | Ops / structure sync | **Final step** |

---

## Not a new request (clarifications)

- [x] Staff certifications listbox = read-only (checkbox to assign)
- [x] Certification entry under QA = shared catalog (Karla's Option A)
- [x] CAR categories = managed in Administration, not hardcoded
- [X] Specs filter = working; Internal Procedure **data** needs to be completed *(part of **E** or post-import on server)*
