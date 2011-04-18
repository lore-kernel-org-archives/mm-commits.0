From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-idt-cps-1432-switch-definitions.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:03 -0700
Message-ID: <201104181759.p3IHxEfw016132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238Ab1DRSEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     RapidIO: add IDT CPS-1432 switch definitions
has been removed from the -mm tree.  Its filename was
     rapidio-add-idt-cps-1432-switch-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RapidIO: add IDT CPS-1432 switch definitions
From: Alexandre Bounine <alexandre.bounine@idt.com>

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen2.c |    1 +
 include/linux/rio_ids.h             |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-add-idt-cps-1432-switch-definitions drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-add-idt-cps-1432-switch-definitions
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -418,3 +418,4 @@ DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1616, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTVPS1616, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTSPS1616, idtg2_switch_init);
+DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1432, idtg2_switch_init);
diff -puN include/linux/rio_ids.h~rapidio-add-idt-cps-1432-switch-definitions include/linux/rio_ids.h
--- a/include/linux/rio_ids.h~rapidio-add-idt-cps-1432-switch-definitions
+++ a/include/linux/rio_ids.h
@@ -35,6 +35,7 @@
 #define RIO_DID_IDTCPS6Q		0x035f
 #define RIO_DID_IDTCPS10Q		0x035e
 #define RIO_DID_IDTCPS1848		0x0374
+#define RIO_DID_IDTCPS1432		0x0375
 #define RIO_DID_IDTCPS1616		0x0379
 #define RIO_DID_IDTVPS1616		0x0377
 #define RIO_DID_IDTSPS1616		0x0378
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

