From: akpm@linux-foundation.org
Subject: - clockchipsh-kernel-doc-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:38 -0700
Message-ID: <200705090252.l492qch3009594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032213AbXEICwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clockchips.h: kernel-doc fix
has been removed from the -mm tree.  Its filename was
     clockchipsh-kernel-doc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clockchips.h: kernel-doc fix
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix misnamed fields of 'struct clock_event_device' in the kernel-doc
comment.  Convert the acronyms to uppercase, while at it...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clockchips.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/clockchips.h~clockchipsh-kernel-doc-fix include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockchipsh-kernel-doc-fix
+++ a/include/linux/clockchips.h
@@ -54,17 +54,17 @@ enum clock_event_nofitiers {
 /**
  * struct clock_event_device - clock event device descriptor
  * @name:		ptr to clock event name
- * @hints:		usage hints
+ * @features:		features
  * @max_delta_ns:	maximum delta value in ns
  * @min_delta_ns:	minimum delta value in ns
  * @mult:		nanosecond to cycles multiplier
  * @shift:		nanoseconds to cycles divisor (power of two)
  * @rating:		variable to rate clock event devices
- * @irq:		irq number (only for non cpu local devices)
- * @cpumask:		cpumask to indicate for which cpus this device works
- * @set_next_event:	set next event
+ * @irq:		IRQ number (only for non CPU local devices)
+ * @cpumask:		cpumask to indicate for which CPUs this device works
+ * @set_next_event:	set next event function
  * @set_mode:		set mode function
- * @evthandler:		Assigned by the framework to be called by the low
+ * @event_handler:	Assigned by the framework to be called by the low
  *			level handler of the event source
  * @broadcast:		function to broadcast events
  * @list:		list head for the management code
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
sl82c105-switch-to-ref-counting-api.patch
3x59x-fix-pci-resource-management.patch
