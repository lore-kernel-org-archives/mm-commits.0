From: akpm@linux-foundation.org
Subject: - quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:19 -0800
Message-ID: <200702122243.l1CMhJxC013489@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030237AbXBLWn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     QUOTA: Have <linux/quota.h> include <linux/rwsem.h> explicitly
has been removed from the -mm tree.  Its filename was
     quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: QUOTA: Have <linux/quota.h> include <linux/rwsem.h> explicitly
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since quota.h declares a R/W semaphore, it should include rwsem.h
explicitly.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quota.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/quota.h~quota-have-linux-quotah-include-linux-rwsemh-explicitly include/linux/quota.h
--- a/include/linux/quota.h~quota-have-linux-quotah-include-linux-rwsemh-explicitly
+++ a/include/linux/quota.h
@@ -132,6 +132,7 @@ struct if_dqinfo {
 
 #ifdef __KERNEL__
 #include <linux/spinlock.h>
+#include <linux/rwsem.h>
 #include <linux/mutex.h>
 
 #include <linux/dqblk_xfs.h>
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
