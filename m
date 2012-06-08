From: akpm@linux-foundation.org
Subject: [merged] maintainers-whitespace-fixes.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:15 -0700
Message-ID: <20120608194115.4E4FCA022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:44261 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233Ab2FHTlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:17 -0400
Received: by lagr15 with SMTP id r15so125162lag.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: whitespace fixes
has been removed from the -mm tree.  Its filename was
     maintainers-whitespace-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: whitespace fixes

Remove trailing spaces at EOL.
Always use a tab after the type :

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN MAINTAINERS~maintainers-whitespace-fixes MAINTAINERS
--- a/MAINTAINERS~maintainers-whitespace-fixes
+++ a/MAINTAINERS
@@ -1077,7 +1077,7 @@ F:	drivers/media/video/s5p-fimc/
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Kamil Debski <k.debski@samsung.com>
-M:     Jeongtae Park <jtp.park@samsung.com>
+M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -1743,10 +1743,10 @@ F:	include/linux/can/platform/
 CAPABILITIES
 M:	Serge Hallyn <serge.hallyn@canonical.com>
 L:	linux-security-module@vger.kernel.org
-S:	Supported	
+S:	Supported
 F:	include/linux/capability.h
 F:	security/capability.c
-F:	security/commoncap.c 
+F:	security/commoncap.c
 F:	kernel/capability.c
 
 CELL BROADBAND ENGINE ARCHITECTURE
@@ -2146,11 +2146,11 @@ S:	Orphan
 F:	drivers/net/wan/pc300*
 
 CYTTSP TOUCHSCREEN DRIVER
-M:      Javier Martinez Canillas <javier@dowhile0.org>
-L:      linux-input@vger.kernel.org
-S:      Maintained
-F:      drivers/input/touchscreen/cyttsp*
-F:      include/linux/input/cyttsp.h
+M:	Javier Martinez Canillas <javier@dowhile0.org>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	drivers/input/touchscreen/cyttsp*
+F:	include/linux/input/cyttsp.h
 
 DAMA SLAVE for AX.25
 M:	Joerg Reuter <jreuter@yaina.de>
@@ -5185,7 +5185,7 @@ S:	Maintained
 F:	drivers/firmware/pcdp.*
 
 PCI ERROR RECOVERY
-M:     Linas Vepstas <linasvepstas@gmail.com>
+M:	Linas Vepstas <linasvepstas@gmail.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

