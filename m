From: akpm@linux-foundation.org
Subject: [folded-merged]
 rapidio-move-net-allocation-into-core-code-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2016 13:54:55 -0700
Message-ID: <56f1b11f.yy7eq+s5liZ84/OT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcCVUy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: move net allocation into core code fix
has been removed from the -mm tree.  Its filename was
     rapidio-move-net-allocation-into-core-code-fix.patch

This patch was dropped because it was folded into rapidio-move-net-allocation-into-core-code.patch

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: move net allocation into core code fix

Fix documentation warning for patch:
	rapidio: move net allocation into core code

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rio.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/rio.h~rapidio-move-net-allocation-into-core-code-fix include/linux/rio.h
--- a/include/linux/rio.h~rapidio-move-net-allocation-into-core-code-fix
+++ a/include/linux/rio.h
@@ -298,6 +298,7 @@ struct rio_mport {
  * @mports: List of master ports accessing this network
  * @hport: Default port for accessing this network
  * @id: RIO network ID
+ * @dev: Device object
  * @enum_data: private data specific to a network enumerator
  * @release: enumerator-specific release callback
  */
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
rapidio-add-global-inbound-port-write-interfaces-fix.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch
rapidio-add-mport-char-device-driver-fix-3.patch
rapidio-add-mport-char-device-driver-fix-4.patch

