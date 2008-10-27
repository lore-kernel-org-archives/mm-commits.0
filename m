From: akpm@linux-foundation.org
Subject: + fs-remove-excess-kernel-doc.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:17:21 -0700
Message-ID: <200810272017.m9RKHL6G012042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbYJ0UR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org


The patch titled
     fs: remove excess kernel-doc
has been added to the -mm tree.  Its filename is
     fs-remove-excess-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: remove excess kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in fs/ subdirectory:

Warning(linux-2.6.27-git10//fs/jbd/transaction.c:886): Excess function parameter or struct member 'credits' description in 'journal_get_undo_access'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/jbd/transaction.c~fs-remove-excess-kernel-doc fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~fs-remove-excess-kernel-doc
+++ a/fs/jbd/transaction.c
@@ -860,7 +860,6 @@ out:
  * int journal_get_undo_access() - Notify intent to modify metadata with non-rewindable consequences
  * @handle: transaction
  * @bh: buffer to undo
- * @credits: store the number of taken credits here (if not NULL)
  *
  * Sometimes there is a need to distinguish between metadata which has
  * been committed to disk and that which has not.  The ext3fs code uses
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
fs-remove-excess-kernel-doc.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

