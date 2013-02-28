From: akpm@linux-foundation.org
Subject: [folded-merged] selftests-add-tests-for-efivarfs-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:48:30 -0800
Message-ID: <20130228004830.AC3AC5A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:33405 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3B1Asb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:48:31 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so140068yen.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:48:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, jk@ozlabs.org, lxiang@redhat.com, matt.fleming@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-add-tests-for-efivarfs-fix
has been removed from the -mm tree.  Its filename was
     selftests-add-tests-for-efivarfs-fix.patch

This patch was dropped because it was folded into selftests-add-tests-for-efivarfs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-add-tests-for-efivarfs-fix

Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/efivarfs/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix tools/testing/selftests/efivarfs/Makefile
--- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
+++ a/tools/testing/selftests/efivarfs/Makefile
@@ -6,7 +6,7 @@ test_objs = open-unlink
 all: $(test_objs)
 
 run_tests: all
-	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
 
 clean:
 	rm -f $(test_objs)
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
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs.patch
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

