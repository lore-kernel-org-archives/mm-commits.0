From: akpm@linux-foundation.org
Subject: - fs-fix-function-param-name-in-kernel-doc.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:26 -0800
Message-ID: <200901072216.n07MGQBf016101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758337AbZAGWQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs: fix function param name in kernel-doc
has been removed from the -mm tree.  Its filename was
     fs-fix-function-param-name-in-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: fix function param name in kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter name in kernel-doc:

Warning(linux-2.6.28-git5//fs/block_dev.c:1272): No description found for parameter 'pathname'
Warning(linux-2.6.28-git5//fs/block_dev.c:1272): Excess function parameter 'path' description in 'lookup_bdev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/block_dev.c~fs-fix-function-param-name-in-kernel-doc fs/block_dev.c
--- a/fs/block_dev.c~fs-fix-function-param-name-in-kernel-doc
+++ a/fs/block_dev.c
@@ -1262,7 +1262,7 @@ EXPORT_SYMBOL(ioctl_by_bdev);
 
 /**
  * lookup_bdev  - lookup a struct block_device by name
- * @path:	special file representing the block device
+ * @pathname:	special file representing the block device
  *
  * Get a reference to the blockdevice at @pathname in the current
  * namespace if possible and return it.  Return ERR_PTR(error)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

