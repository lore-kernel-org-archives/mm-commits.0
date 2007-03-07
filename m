From: akpm@linux-foundation.org
Subject: + rocket-remove-modversions-include.patch added to -mm tree
Date: Wed, 07 Mar 2007 15:55:15 -0800
Message-ID: <200703072355.l27NtF4b013583@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXCGXzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:55:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     rocket: remove modversions include
has been added to the -mm tree.  Its filename is
     rocket-remove-modversions-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rocket: remove modversions include
From: "Robert P. J. Day" <rpjday@mindspring.com>

It misspelled "MODVERSIONS" preprocessor variable with "CONFIG_MODVERSIONS". 
Just kill it all.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    4 ----
 1 files changed, 4 deletions(-)

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

git-avr32.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
