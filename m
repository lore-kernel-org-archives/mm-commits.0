From: akpm@linux-foundation.org
Subject: - ecryptfs-generalize-metadata-read-write-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:24:48 -0800
Message-ID: <200702120724.l1C7Omwv024768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45151 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069AbXBLHgX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: printk warning fix
has been removed from the -mm tree.  Its filename was
     ecryptfs-generalize-metadata-read-write-fix.patch

This patch was dropped because it was folded into ecryptfs-generalize-metadata-read-write.patch

------------------------------------------------------
Subject: ecryptfs: printk warning fix
From: Andrew Morton <akpm@osdl.org>

fs/ecryptfs/crypto.c: In function 'ecryptfs_read_xattr_region':
fs/ecryptfs/crypto.c:1575: warning: format '%d' expects type 'int', but argument 3 has type 'ssize_t'

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-generalize-metadata-read-write-fix fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-generalize-metadata-read-write-fix
+++ a/fs/ecryptfs/crypto.c
@@ -1559,7 +1559,7 @@ int ecryptfs_read_xattr_region(char *pag
 				 page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
 	if (size < 0) {
 		printk(KERN_DEBUG "Error attempting to read the [%s] "
-		       "xattr from the lower file; return value = [%d]\n",
+		       "xattr from the lower file; return value = [%zd]\n",
 		       ECRYPTFS_XATTR_NAME, size);
 		rc = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-generalize-metadata-read-write-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
