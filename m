From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-video-implement-a-simple-framebuffer-driver-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:42:55 -0700
Message-ID: <20130429214256.462A55A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50870 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab3D2Vm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:42:58 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so106807vbf.5
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:42:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, arnd@arndb.de, olof@lixom.net, robclark@gmail.com, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-video-implement-a-simple-framebuffer-driver-fix
has been removed from the -mm tree.  Its filename was
     drivers-video-implement-a-simple-framebuffer-driver-fix.patch

This patch was dropped because it was folded into drivers-video-implement-a-simple-framebuffer-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-video-implement-a-simple-framebuffer-driver-fix

make simplefb_formats[] static

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Rob Clark <robclark@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/simplefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/simplefb.c~drivers-video-implement-a-simple-framebuffer-driver-fix drivers/video/simplefb.c
--- a/drivers/video/simplefb.c~drivers-video-implement-a-simple-framebuffer-driver-fix
+++ a/drivers/video/simplefb.c
@@ -82,7 +82,7 @@ struct simplefb_format {
 	struct fb_bitfield transp;
 };
 
-struct simplefb_format simplefb_formats[] = {
+static struct simplefb_format simplefb_formats[] = {
 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

