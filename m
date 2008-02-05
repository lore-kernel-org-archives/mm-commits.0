From: akpm@linux-foundation.org
Subject: - m68knommu-removing-config-variable-dumptoflash.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:38 -0800
Message-ID: <200802052233.m15MXJ15012395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762271AbYBEWl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: removing config variable DUMPTOFLASH
has been removed from the -mm tree.  Its filename was
     m68knommu-removing-config-variable-dumptoflash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: removing config variable DUMPTOFLASH
From: Jiri Olsa <olsajiri@gmail.com>

Removing config variable DUMPTOFLASH, since it is not used

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/Kconfig.debug |    7 -------
 arch/m68knommu/defconfig     |    1 -
 2 files changed, 8 deletions(-)

diff -puN arch/m68knommu/Kconfig.debug~m68knommu-removing-config-variable-dumptoflash arch/m68knommu/Kconfig.debug
--- a/arch/m68knommu/Kconfig.debug~m68knommu-removing-config-variable-dumptoflash
+++ a/arch/m68knommu/Kconfig.debug
@@ -21,13 +21,6 @@ config BOOTPARAM_STRING
 	default 'console=ttyS0,19200'
 	depends on BOOTPARAM
 
-config DUMPTOFLASH
-	bool "Panic/Dump to FLASH"
-	depends on COLDFIRE
-	help
-	  Dump any panic of trap output into a flash memory segment
-	  for later analysis.
-
 config NO_KERNEL_MSG
 	bool "Suppress Kernel BUG Messages"
 	help
diff -puN arch/m68knommu/defconfig~m68knommu-removing-config-variable-dumptoflash arch/m68knommu/defconfig
--- a/arch/m68knommu/defconfig~m68knommu-removing-config-variable-dumptoflash
+++ a/arch/m68knommu/defconfig
@@ -597,7 +597,6 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_FULLDEBUG is not set
 # CONFIG_HIGHPROFILE is not set
 # CONFIG_BOOTPARAM is not set
-# CONFIG_DUMPTOFLASH is not set
 # CONFIG_NO_KERNEL_MSG is not set
 # CONFIG_BDM_DISABLE is not set
 
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
