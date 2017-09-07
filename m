From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Thu, 07 Sep 2017 11:35:14 -0700
Message-ID: <20170907183514.ANNZMA2F3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755218AbdIGSfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/configs/se7751_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/sh/configs/se7751_defconfig~linux-next-rejects arch/sh/configs/se7751_defconfig
--- a/arch/sh/configs/se7751_defconfig~linux-next-rejects
+++ a/arch/sh/configs/se7751_defconfig
@@ -26,7 +26,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=y
-CONFIG_NETFILTER_DEBUG=y
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

