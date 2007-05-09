From: akpm@linux-foundation.org
Subject: - rocket-remove-modversions-include.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:17 -0700
Message-ID: <200705090246.l492kH78008833@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbXEICqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     rocket: remove modversions include
has been removed from the -mm tree.  Its filename was
     rocket-remove-modversions-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rocket: remove modversions include
From: "Robert P. J. Day" <rpjday@mindspring.com>

It misspelled "MODVERSIONS" preprocessor variable with "CONFIG_MODVERSIONS". 
Just kill it all.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/rocket.c~rocket-remove-modversions-include drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-remove-modversions-include
+++ a/drivers/char/rocket.c
@@ -65,10 +65,6 @@
 
 /****** Kernel includes ******/
 
-#ifdef MODVERSIONS
-#include <config/modversions.h>
-#endif				
-
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/major.h>
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
