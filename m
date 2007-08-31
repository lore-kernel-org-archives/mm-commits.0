From: akpm@linux-foundation.org
Subject: - rfc-add-bcm947xx-to-kconfig.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:34:51 -0700
Message-ID: <200708310634.l7V6YpnY027732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761539AbXHaGgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, jolt@tuxbox.org, mb@bu3sch.de, nbd@openwrt.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Add BCM947XX to Kconfig
has been removed from the -mm tree.  Its filename was
     rfc-add-bcm947xx-to-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add BCM947XX to Kconfig
From: Aurelien Jarno <aurelien@aurel32.net>

Add a BCM947XX option to Kconfig.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Florian Schirmer <jolt@tuxbox.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN arch/mips/Kconfig~rfc-add-bcm947xx-to-kconfig arch/mips/Kconfig
--- a/arch/mips/Kconfig~rfc-add-bcm947xx-to-kconfig
+++ a/arch/mips/Kconfig
@@ -45,6 +45,20 @@ config BASLER_EXCITE_PROTOTYPE
 	  note that a kernel built with this option selected will not be
 	  able to run on normal units.
 
+config BCM947XX
+	bool "BCM947xx based boards"
+	select DMA_NONCOHERENT
+	select HW_HAS_PCI
+	select IRQ_CPU
+	select SYS_HAS_CPU_MIPS32_R1
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select SSB
+	select SSB_DRIVER_MIPS
+	select GENERIC_GPIO
+	help
+	 Support for BCM947xx based boards
+
 config MIPS_COBALT
 	bool "Cobalt Server"
 	select DMA_NONCOHERENT
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-mips.patch
mips-bcm947xx-support.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
