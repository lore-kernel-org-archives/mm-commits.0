From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:39 -0700
Message-ID: <200705291853.l4TIrctA008474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbXE2Syz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, ben-linux@fluff.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: arch/arm/mach-s3c2410/bast.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: arch/arm/mach-s3c2410/bast.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/bast.h |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/arm/mach-s3c2410/bast.h~remove-unused-header-file-arch-arm-mach-s3c2410-basth /dev/null
--- a/arch/arm/mach-s3c2410/bast.h
+++ /dev/null
@@ -1,2 +0,0 @@
-/* linux/arch/arm/mach-s3c2410/bast.h
-extern void bast_init_irq(void);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
git-ieee1394.patch
git-kbuild.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
