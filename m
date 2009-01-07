From: akpm@linux-foundation.org
Subject: - rapidio-remove-excess-kernel-doc-notation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:09 -0800
Message-ID: <200901072220.n07MK95Q019424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763383AbZAGWhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: remove excess kernel-doc notation
has been removed from the -mm tree.  Its filename was
     rapidio-remove-excess-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: remove excess kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc notation from rio header and driver:

Warning(include/linux/rio_drv.h:399): Excess function parameter or struct member 'buffer' description in 'rio_get_inb_message'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c |    1 -
 include/linux/rio_drv.h      |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/rapidio/rio-driver.c~rapidio-remove-excess-kernel-doc-notation drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-remove-excess-kernel-doc-notation
+++ a/drivers/rapidio/rio-driver.c
@@ -79,7 +79,6 @@ void rio_dev_put(struct rio_dev *rdev)
 
 /**
  *  rio_device_probe - Tell if a RIO device structure has a matching RIO device id structure
- *  @id: the RIO device id structure to match against
  *  @dev: the RIO device structure to match against
  *
  * return 0 and set rio_dev->driver when drv claims rio_dev, else error
diff -puN include/linux/rio_drv.h~rapidio-remove-excess-kernel-doc-notation include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-remove-excess-kernel-doc-notation
+++ a/include/linux/rio_drv.h
@@ -391,7 +391,6 @@ static inline int rio_add_inb_buffer(str
  * rio_get_inb_message - Get A RIO message from an inbound mailbox queue
  * @mport: Master port containing the inbound mailbox
  * @mbox: The inbound mailbox number
- * @buffer: Pointer to the message buffer
  *
  * Get a RIO message from an inbound mailbox queue. Returns 0 on success.
  */
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

