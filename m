From: akpm@linux-foundation.org
Subject: - mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:26 -0800
Message-ID: <200702282352.l1SNqQij030995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776AbXB1Xzo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: Remove unreferenced _IOC_SLMASK macro in ioctl.h
has been removed from the -mm tree.  Its filename was
     mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: Remove unreferenced _IOC_SLMASK macro in ioctl.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete the definition of the apparently unreferenced macro _IOC_SLMASK.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/ioctl.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/asm-mips/ioctl.h~mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh include/asm-mips/ioctl.h
--- a/include/asm-mips/ioctl.h~mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh
+++ a/include/asm-mips/ioctl.h
@@ -38,11 +38,6 @@
 #define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)
 
 /*
- * We to additionally limit parameters to a maximum 255 bytes.
- */
-#define _IOC_SLMASK	0xff
-
-/*
  * Direction bits _IOC_NONE could be 0, but OSF/1 gives it a bit.
  * And this turns out useful to catch old ioctl numbers in header
  * files for us.
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
