From: akpm@linux-foundation.org
Subject: - ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:05 -0800
Message-ID: <200702122243.l1CMh5Dd013469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030230AbXBLWnL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     NTFS: rename incorrect check of NTFS_DEBUG with just DEBUG
has been removed from the -mm tree.  Its filename was
     ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NTFS: rename incorrect check of NTFS_DEBUG with just DEBUG
From: Robert P. J. Day <rpjday@mindspring.com>

Replace the incorrect debugging check of "#ifdef NTFS_DEBUG" with
just "#ifdef DEBUG".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ntfs/attrib.c~ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug fs/ntfs/attrib.c
--- a/fs/ntfs/attrib.c~ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug
+++ a/fs/ntfs/attrib.c
@@ -1921,7 +1921,7 @@ s64 ntfs_attr_extend_allocation(ntfs_ino
 	u32 attr_len = 0; /* Silence stupid gcc warning. */
 	bool mp_rebuilt;
 
-#ifdef NTFS_DEBUG
+#ifdef DEBUG
 	read_lock_irqsave(&ni->size_lock, flags);
 	allocated_size = ni->allocated_size;
 	read_unlock_irqrestore(&ni->size_lock, flags);
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
