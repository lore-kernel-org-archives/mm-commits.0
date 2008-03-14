From: akpm@linux-foundation.org
Subject: + jbd-fix-jbd-kernel-doc-notation.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:19:27 -0700
Message-ID: <200803141919.m2EJJRNw015188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYCNTXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     jbd: fix jbd kernel-doc notation
has been added to the -mm tree.  Its filename is
     jbd-fix-jbd-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix jbd kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in jbd.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c     |    5 +++--
 fs/jbd/transaction.c |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/jbd/journal.c~jbd-fix-jbd-kernel-doc-notation fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-fix-jbd-kernel-doc-notation
+++ a/fs/jbd/journal.c
@@ -697,13 +697,14 @@ fail:
  */
 
 /**
- *  journal_t * journal_init_dev() - creates an initialises a journal structure
+ *  journal_t * journal_init_dev() - creates and initialises a journal structure
  *  @bdev: Block device on which to create the journal
  *  @fs_dev: Device which hold journalled filesystem for this journal.
  *  @start: Block nr Start of journal.
  *  @len:  Length of the journal in blocks.
  *  @blocksize: blocksize of journalling device
- *  @returns: a newly created journal_t *
+ *
+ *  Returns: a newly created journal_t *
  *
  *  journal_init_dev creates a journal which maps a fixed contiguous
  *  range of blocks on an arbitrary block device.
diff -puN fs/jbd/transaction.c~jbd-fix-jbd-kernel-doc-notation fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-fix-jbd-kernel-doc-notation
+++ a/fs/jbd/transaction.c
@@ -1426,7 +1426,8 @@ int journal_stop(handle_t *handle)
 	return err;
 }
 
-/**int journal_force_commit() - force any uncommitted transactions
+/**
+ * int journal_force_commit() - force any uncommitted transactions
  * @journal: journal to force
  *
  * For synchronous operations: force any uncommitted transactions
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-set-verbose-mode-via-environment.patch
mm-fix-various-kernel-doc-comments.patch
mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch
mm-oom_kill-fix-kernel-doc.patch
mm-highmem-kernel-doc-additions.patch
mm-rmap-kernel-doc-fixes.patch
jbd-fix-jbd-kernel-doc-notation.patch
git-acpi.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
profile-likely-unlikely-macros.patch

