From: akpm@linux-foundation.org
Subject: + m68knommu-removing-config-variable-dumptoflash.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:09:17 -0800
Message-ID: <200711160309.lAG39Hff029418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbXKPDJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, gerg@snapgear.com


The patch titled
     m68knommu: removing config variable DUMPTOFLASH
has been added to the -mm tree.  Its filename is
     m68knommu-removing-config-variable-dumptoflash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: removing config variable DUMPTOFLASH
From: Jiri Olsa <olsajiri@gmail.com>

Removing config variable DUMPTOFLASH, since it is not used

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/Kconfig.debug |    7 -------
 arch/m68knommu/defconfig     |    1 -
 2 files changed, 8 deletions(-)

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
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch
git-alsa.patch
arm-remove-dead-config-symbols-from-arm-code.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
mips-remove-dead-config-symbols-from-mips-code.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
frv-remove-dead-config-symbol-from-frv-code.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
