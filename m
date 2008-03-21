From: akpm@linux-foundation.org
Subject: - jbd-fix-jbd-kernel-doc-notation.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:09 -0700
Message-ID: <200803212029.m2LKT97m008844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757631AbYCUU3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     jbd: fix jbd kernel-doc notation
has been removed from the -mm tree.  Its filename was
     jbd-fix-jbd-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

