From: akpm@linux-foundation.org
Subject: - md-replace-misspelled-printk-with-config_printk.patch removed from -mm tree
Date: Wed, 07 Mar 2007 16:17:42 -0800
Message-ID: <200703080019.l280JPkg014078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992468AbXCHATc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 19:19:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: replace misspelled "PRINTK" with "CONFIG_PRINTK"
has been removed from the -mm tree.  Its filename was
     md-replace-misspelled-printk-with-config_printk.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: md: replace misspelled "PRINTK" with "CONFIG_PRINTK"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparently misspelled preprocessor variable "PRINTK" with
"CONFIG_PRINTK".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/bitmap.c~md-replace-misspelled-printk-with-config_printk drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-replace-misspelled-printk-with-config_printk
+++ a/drivers/md/bitmap.c
@@ -53,7 +53,7 @@
 //#define DPRINTK PRINTK /* set this NULL to avoid verbose debug output */
 #define DPRINTK(x...) do { } while(0)
 
-#ifndef PRINTK
+#ifndef CONFIG_PRINTK
 #  if DEBUG > 0
 #    define PRINTK(x...) printk(KERN_DEBUG x)
 #  else
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
mtd-correct-misspelled-preprocessor-variable.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
md-replace-misspelled-printk-with-config_printk.patch
