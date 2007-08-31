From: akpm@linux-foundation.org
Subject: - mips-add-bcm947xx-to-makefile.patch removed from -mm tree
Date: Fri, 31 Aug 2007 08:25:48 -0700
Message-ID: <200708311525.l7VFPmSN014215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757270AbXHaP1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 11:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, jolt@tuxbox.org, mb@bu3sch.de, nbd@openwrt.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: Add BCM947xx to Makefile
has been removed from the -mm tree.  Its filename was
     mips-add-bcm947xx-to-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: Add BCM947xx to Makefile
From: Aurelien Jarno <aurelien@aurel32.net>

Add BCM947xx to arch/mips/Makefile.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Florian Schirmer <jolt@tuxbox.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Makefile |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/mips/Makefile~mips-add-bcm947xx-to-makefile arch/mips/Makefile
--- a/arch/mips/Makefile~mips-add-bcm947xx-to-makefile
+++ a/arch/mips/Makefile
@@ -528,6 +528,13 @@ libs-$(CONFIG_SIBYTE_BIGSUR)	+= arch/mip
 load-$(CONFIG_SIBYTE_BIGSUR)	:= 0xffffffff80100000
 
 #
+# Broadcom BCM947XX boards
+#
+core-$(CONFIG_BCM947XX)		+= arch/mips/bcm947xx/
+cflags-$(CONFIG_BCM947XX)	+= -Iinclude/asm-mips/mach-bcm947xx
+load-$(CONFIG_BCM947XX)		:= 0xffffffff80001000
+
+#
 # SNI RM
 #
 core-$(CONFIG_SNI_RM)		+= arch/mips/sni/
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
