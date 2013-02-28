From: akpm@linux-foundation.org
Subject: [folded-merged] idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:46:29 -0800
Message-ID: <20130228004630.5A39A31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:46884 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1Aqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:46:31 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so139717yen.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:46:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch

This patch was dropped because it was folded into idr-remove-length-restriction-from-idr_layer-bitmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes

ERROR: space required before the open brace '{'
#141: FILE: lib/idr.c:525:
+	if (likely(p != NULL && test_bit(n, p->bitmap))){

total: 1 errors, 0 warnings, 140 lines checked

./patches/idr-remove-length-restriction-from-idr_layer-bitmap.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/idr.c~idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes lib/idr.c
--- a/lib/idr.c~idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes
+++ a/lib/idr.c
@@ -522,7 +522,7 @@ static void sub_remove(struct idr *idp, 
 		shift -= IDR_BITS;
 	}
 	n = id & IDR_MASK;
-	if (likely(p != NULL && test_bit(n, p->bitmap))){
+	if (likely(p != NULL && test_bit(n, p->bitmap))) {
 		__clear_bit(n, p->bitmap);
 		rcu_assign_pointer(p->ary[n], NULL);
 		to_free = NULL;
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
idr-remove-length-restriction-from-idr_layer-bitmap.patch
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

