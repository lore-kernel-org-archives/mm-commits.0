From: akpm@linux-foundation.org
Subject: + clockchipsh-kernel-doc-fix.patch added to -mm tree
Date: Thu, 03 May 2007 02:29:13 -0700
Message-ID: <200705030929.l439TDOa008908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965539AbXECJ33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 05:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, tglx@linutronix.de


The patch titled
     clockchips.h: kernel-doc fix
has been added to the -mm tree.  Its filename is
     clockchipsh-kernel-doc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
clockchipsh-kernel-doc-fix.patch
