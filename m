From: akpm@linux-foundation.org
Subject: [folded-dropped] fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:42:05 -0800
Message-ID: <20130228004205.9BF625A42AE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59645 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1AmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:42:06 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so138706ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:42:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:VxV)
#45: FILE: fs/seq_file.c:318:
+			while ((retval=traverse(m, offset)) == -EAGAIN)
 			              ^

total: 1 errors, 0 warnings, 47 lines checked

./patches/fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/seq_file.c~fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes
+++ a/fs/seq_file.c
@@ -315,7 +315,7 @@ loff_t seq_lseek(struct file *file, loff
 			break;
 		retval = offset;
 		if (offset != m->read_pos) {
-			while ((retval=traverse(m, offset)) == -EAGAIN)
+			while ((retval = traverse(m, offset)) == -EAGAIN)
 				;
 			if (retval) {
 				/* with extreme prejudice... */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

