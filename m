From: akpm@linux-foundation.org
Subject: - virtio_blk-fix-type-warning.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:10 -0800
Message-ID: <200812011949.mB1JnARv025126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYLATtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     virtio_blk: fix type warning
has been removed from the -mm tree.  Its filename was
     virtio_blk-fix-type-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: virtio_blk: fix type warning
From: Randy Dunlap <randy.dunlap@oracle.com>

linux-next-20081126/drivers/block/virtio_blk.c:307: warning: large integer implicitly truncated to unsigned type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/virtio_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/virtio_blk.c~virtio_blk-fix-type-warning drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c~virtio_blk-fix-type-warning
+++ a/drivers/block/virtio_blk.c
@@ -304,7 +304,7 @@ static int virtblk_probe(struct virtio_d
 	if (!err)
 		blk_queue_max_segment_size(vblk->disk->queue, v);
 	else
-		blk_queue_max_segment_size(vblk->disk->queue, -1UL);
+		blk_queue_max_segment_size(vblk->disk->queue, -1U);
 
 	/* Host can optionally specify the block size of the device */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_SIZE,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
backlight-catch-invalid-input-fix.patch
esp-fix-section-mismatch-warning.patch
kernel-doc-handle-varargs-cleanly.patch
ntfs-dont-fool-kernel-doc.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
document-hadling-of-bad-memory.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
fix-similar-typos-to-successfull-v2.patch

