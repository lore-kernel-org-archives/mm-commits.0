From: akpm@linux-foundation.org
Subject: +
 mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors.patch added to -mm tree
Date: Tue, 23 Jan 2018 14:34:07 -0800
Message-ID: <5a67b85f.mmx8acCwfI88400p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932150AbeAWWeI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jan 2018 17:34:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: docs: add blank lines to silence sphinx "Unexpected indentation" errors
has been added to the -mm tree.  Its filename is
     mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: mm: docs: add blank lines to silence sphinx "Unexpected indentation" errors

Link: http://lkml.kernel.org/r/1516700871-22279-4-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c          |    1 +
 mm/process_vm_access.c |    2 ++
 mm/vmscan.c            |    1 +
 3 files changed, 4 insertions(+)

diff -puN mm/pagewalk.c~mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors mm/pagewalk.c
--- a/mm/pagewalk.c~mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors
+++ a/mm/pagewalk.c
@@ -265,6 +265,7 @@ static int __walk_page_range(unsigned lo
  * pte_entry(), and/or hugetlb_entry(). If you don't set up for some of these
  * callbacks, the associated entries/pages are just ignored.
  * The return values of these callbacks are commonly defined like below:
+ *
  *  - 0  : succeeded to handle the current entry, and if you don't reach the
  *         end address yet, continue to walk.
  *  - >0 : succeeded to handle the current entry, and return to the caller
diff -puN mm/process_vm_access.c~mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors mm/process_vm_access.c
--- a/mm/process_vm_access.c~mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors
+++ a/mm/process_vm_access.c
@@ -147,6 +147,7 @@ static int process_vm_rw_single_vec(unsi
  * @riovcnt: size of rvec array
  * @flags: currently unused
  * @vm_write: 0 if reading from other process, 1 if writing to other process
+ *
  * Returns the number of bytes read/written or error code. May
  *  return less bytes than expected if an error occurs during the copying
  *  process.
@@ -253,6 +254,7 @@ free_proc_pages:
  * @riovcnt: size of rvec array
  * @flags: currently unused
  * @vm_write: 0 if reading from other process, 1 if writing to other process
+ *
  * Returns the number of bytes read/written or error code. May
  *  return less bytes than expected if an error occurs during the copying
  *  process.
diff -puN mm/vmscan.c~mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors mm/vmscan.c
--- a/mm/vmscan.c~mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors
+++ a/mm/vmscan.c
@@ -1545,6 +1545,7 @@ static unsigned long isolate_lru_pages(u
  * found will be decremented.
  *
  * Restrictions:
+ *
  * (1) Must be called with an elevated refcount on the page. This is a
  *     fundamentnal difference from isolate_lru_pages (which is called
  *     without a stable reference).
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

mm-update-comment-describing-tlb_gather_mmu.patch
mm-docs-fixup-punctuation.patch
mm-docs-fix-parameter-names-mismatch.patch
mm-docs-add-blank-lines-to-silence-sphinx-unexpected-indentation-errors.patch
pids-introduce-find_get_task_by_vpid-helper.patch

