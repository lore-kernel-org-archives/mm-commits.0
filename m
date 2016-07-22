From: akpm@linux-foundation.org
Subject: +
 rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch added to -mm tree
Date: Fri, 22 Jul 2016 11:26:16 -0700
Message-ID: <57926548.lWpo4NTTRMJ/+hH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbcGVS0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 14:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix DocBook warning for gen3 update
has been added to the -mm tree.  Its filename is
     rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch

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
Subject: rapidio: fix DocBook warning for gen3 update

Add missing parameter description to fix kbuild warning for patch
"rapidio: modify for rev.3 specification changes".

Link: http://lkml.kernel.org/r/1469191173-19338-1-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rapidio/rio.c~rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update
+++ a/drivers/rapidio/rio.c
@@ -786,6 +786,7 @@ EXPORT_SYMBOL_GPL(rio_unmap_outb_region)
  * @local: Indicate a local master port or remote device access
  * @destid: Destination ID of the device
  * @hopcount: Number of switch hops to the device
+ * @rmap: pointer to location to store register map type info
  */
 u32
 rio_mport_get_physefb(struct rio_mport *port, int local,
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch
rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch

