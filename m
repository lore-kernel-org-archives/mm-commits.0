From: akpm@linux-foundation.org
Subject: - jbd2-fix-kernel-doc-notation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:11 -0700
Message-ID: <200804300552.m3U5qB4J030295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757949AbYD3Fxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jbd2: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     jbd2-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in jbd2.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c     |    5 +++--
 fs/jbd2/transaction.c |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-fix-kernel-doc-notation fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-fix-kernel-doc-notation
+++ a/fs/jbd2/journal.c
@@ -1006,13 +1006,14 @@ fail:
  */
 
 /**
- *  journal_t * jbd2_journal_init_dev() - creates an initialises a journal structure
+ *  journal_t * jbd2_journal_init_dev() - creates and initialises a journal structure
  *  @bdev: Block device on which to create the journal
  *  @fs_dev: Device which hold journalled filesystem for this journal.
  *  @start: Block nr Start of journal.
  *  @len:  Length of the journal in blocks.
  *  @blocksize: blocksize of journalling device
- *  @returns: a newly created journal_t *
+ *
+ *  Returns: a newly created journal_t *
  *
  *  jbd2_journal_init_dev creates a journal which maps a fixed contiguous
  *  range of blocks on an arbitrary block device.
diff -puN fs/jbd2/transaction.c~jbd2-fix-kernel-doc-notation fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-fix-kernel-doc-notation
+++ a/fs/jbd2/transaction.c
@@ -1462,7 +1462,8 @@ int jbd2_journal_stop(handle_t *handle)
 	return err;
 }
 
-/**int jbd2_journal_force_commit() - force any uncommitted transactions
+/**
+ * int jbd2_journal_force_commit() - force any uncommitted transactions
  * @journal: journal to force
  *
  * For synchronous operations: force any uncommitted transactions
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

