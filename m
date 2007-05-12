From: akpm@linux-foundation.org
Subject: - arm-remove-useless-config-option-generic_bust_spinlock.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:01 -0700
Message-ID: <200705120536.l4C5a1cF002343@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666AbXELFgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ARM: remove useless config option GENERIC_BUST_SPINLOCK
has been removed from the -mm tree.  Its filename was
     arm-remove-useless-config-option-generic_bust_spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM: remove useless config option GENERIC_BUST_SPINLOCK
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the apparently useless config option GENERIC_BUST_SPINLOCK,
since nothing in the source tree refers to it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arm/Kconfig~arm-remove-useless-config-option-generic_bust_spinlock arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-remove-useless-config-option-generic_bust_spinlock
+++ a/arch/arm/Kconfig
@@ -114,9 +114,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_BUST_SPINLOCK
-	bool
-
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-arm.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
