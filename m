From: akpm@linux-foundation.org
Subject: + rapidio-remove-excess-kernel-doc-notation.patch added to -mm tree
Date: Mon, 03 Nov 2008 16:39:28 -0800
Message-ID: <200811040039.mA40dSE6030571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYKDAjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 19:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mporter@kernel.crashing.org


The patch titled
     rapidio: remove excess kernel-doc notation
has been added to the -mm tree.  Its filename is
     rapidio-remove-excess-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
fusion-remove-excess-kernel-doc-notation.patch
profile-likely-unlikely-macros.patch

