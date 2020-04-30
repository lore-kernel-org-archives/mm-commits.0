From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fix.patch removed from -mm tree
Date: Thu, 30 Apr 2020 12:12:36 -0700
Message-ID: <20200430191236.Q9vSokh1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgD3TMh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 15:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been removed from the -mm tree.  Its filename was
     linux-next-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/macintosh/Makefile~linux-next-fix
+++ a/drivers/macintosh/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_MAC_EMUMOUSEBTN)	+= mac_hid
 obj-$(CONFIG_INPUT_ADBHID)	+= adbhid.o
 obj-$(CONFIG_ANSLCD)		+= ans-lcd.o
 
-obj-$(CONFIG_ADB_PMU)		+= via-pmu.o via-pmu-event.o
+obj-$(CONFIG_ADB_PMU)		+= via-pmu-event.o
 obj-$(CONFIG_ADB_PMU_LED)	+= via-pmu-led.o
 obj-$(CONFIG_PMAC_BACKLIGHT)	+= via-pmu-backlight.o
 obj-$(CONFIG_ADB_CUDA)		+= via-cuda.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
