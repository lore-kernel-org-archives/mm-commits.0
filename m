From: akpm@linux-foundation.org
Subject: + rapidio-move-rio_pw_enable-into-core-code-fix.patch added to
 -mm tree
Date: Wed, 10 Feb 2016 10:50:17 -0800
Message-ID: <56bb8669.icKifT2/mmCBl2Ur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbcBJSuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 13:50:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: move rio_pw_enable into core code fix
has been added to the -mm tree.  Its filename is
     rapidio-move-rio_pw_enable-into-core-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-move-rio_pw_enable-into-core-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-move-rio_pw_enable-into-core-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: move rio_pw_enable into core code fix

Fix documentation warning for patch:
	rapidio: move rio_pw_enable into core code

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio.c~rapidio-move-rio_pw_enable-into-core-code-fix drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-move-rio_pw_enable-into-core-code-fix
+++ a/drivers/rapidio/rio.c
@@ -561,7 +561,7 @@ EXPORT_SYMBOL_GPL(rio_release_inb_pwrite
 
 /**
  * rio_pw_enable - Enables/disables port-write handling by a master port
- * @port: Master port associated with port-write handling
+ * @mport: Master port associated with port-write handling
  * @enable:  1=enable,  0=disable
  */
 void rio_pw_enable(struct rio_mport *mport, int enable)
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-move-net-allocation-into-core-code-fix.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-add-lock-protection-for-doorbell-list-fix.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-move-rio_pw_enable-into-core-code-fix.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch

