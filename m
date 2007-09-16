From: akpm@linux-foundation.org
Subject: - h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:45 -0700
Message-ID: <200709160925.l8G9PjAc009130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbXIPJ0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:26:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, satyam@infradead.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     H8/300: Fix misnamed "CONFIG_BLKDEV_RESERVE_ADDRESS" Kconfig variable
has been removed from the -mm tree.  Its filename was
     h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: H8/300: Fix misnamed "CONFIG_BLKDEV_RESERVE_ADDRESS" Kconfig variable
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Satyam Sharma <satyam@infradead.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig.debug |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/Kconfig.debug~h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable arch/h8300/Kconfig.debug
--- a/arch/h8300/Kconfig.debug~h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable
+++ a/arch/h8300/Kconfig.debug
@@ -59,7 +59,7 @@ config BLKDEV_RESERVE
 	help
 	  Reserved BLKDEV area.
 
-config CONFIG_BLKDEV_RESERVE_ADDRESS
+config BLKDEV_RESERVE_ADDRESS
 	hex 'start address'
 	depends on BLKDEV_RESERVE
 	help
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
m32r-serial-remove-m32r_sio_share_irqs.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
documentation-delete-unreferenced-xterm-linuxxpm-file.patch
