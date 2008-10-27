From: akpm@linux-foundation.org
Subject: + block-remove-excess-kernel-doc.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:16:48 -0700
Message-ID: <200810272016.m9RKGmDV011863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbYJ0UR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, axboe@kernel.dk


The patch titled
     block: remove excess kernel-doc
has been added to the -mm tree.  Its filename is
     block-remove-excess-kernel-doc.patch

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
Subject: block: remove excess kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in block/ subdirectory:

Warning(linux-2.6.27-git10//block/blk-tag.c:164): Excess function parameter or struct member 'tags' description in 'blk_init_tags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-tag.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN block/blk-tag.c~block-remove-excess-kernel-doc block/blk-tag.c
--- a/block/blk-tag.c~block-remove-excess-kernel-doc
+++ a/block/blk-tag.c
@@ -158,7 +158,6 @@ fail:
 /**
  * blk_init_tags - initialize the tag info for an external tag map
  * @depth:	the maximum queue depth supported
- * @tags: the tag to use
  **/
 struct blk_queue_tag *blk_init_tags(int depth)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
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

