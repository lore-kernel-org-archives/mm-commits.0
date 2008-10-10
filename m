From: akpm@linux-foundation.org
Subject: + remove-andrew-mortons-old-email-accounts-fix.patch added to -mm tree
Date: Fri, 10 Oct 2008 15:07:18 -0700
Message-ID: <200810102207.m9AM7IVQ008379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbYJJWHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 18:07:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: francois.cami@free.fr


The patch titled
     Remove Andrew Morton's andrewm@uow.edu.au
has been added to the -mm tree.  Its filename is
     remove-andrew-mortons-old-email-accounts-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove Andrew Morton's andrewm@uow.edu.au
From: FD Cami <francois.cami@free.fr>

Remove Andrew Morton's andrewm@uow.edu.au email address.
I totally missed that one on my first pass.

Signed-off-by: Francois Cami <francois.cami@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/cs89x0.txt |    2 +-
 Documentation/networking/vortex.txt |    2 +-
 drivers/char/vt.c                   |    2 +-
 drivers/net/3c509.c                 |    2 +-
 drivers/net/cs89x0.c                |   13 ++++++-------
 drivers/parport/ChangeLog           |    2 +-
 kernel/printk.c                     |    2 +-
 kernel/workqueue.c                  |    2 +-
 8 files changed, 13 insertions(+), 14 deletions(-)

diff -puN Documentation/networking/cs89x0.txt~remove-andrew-mortons-old-email-accounts-fix Documentation/networking/cs89x0.txt
--- a/Documentation/networking/cs89x0.txt~remove-andrew-mortons-old-email-accounts-fix
+++ a/Documentation/networking/cs89x0.txt
@@ -3,7 +3,7 @@ NOTE
 ----
 
 This document was contributed by Cirrus Logic for kernel 2.2.5.  This version
-has been updated for 2.3.48 by Andrew Morton <andrewm@uow.edu.au>
+has been updated for 2.3.48 by Andrew Morton.
 
 Cirrus make a copy of this driver available at their website, as
 described below.  In general, you should use the driver version which
diff -puN Documentation/networking/vortex.txt~remove-andrew-mortons-old-email-accounts-fix Documentation/networking/vortex.txt
--- a/Documentation/networking/vortex.txt~remove-andrew-mortons-old-email-accounts-fix
+++ a/Documentation/networking/vortex.txt
@@ -1,5 +1,5 @@
 Documentation/networking/vortex.txt
-Andrew Morton <andrewm@uow.edu.au>
+Andrew Morton
 30 April 2000
 
 
diff -puN drivers/char/vt.c~remove-andrew-mortons-old-email-accounts-fix drivers/char/vt.c
--- a/drivers/char/vt.c~remove-andrew-mortons-old-email-accounts-fix
+++ a/drivers/char/vt.c
@@ -59,7 +59,7 @@
  * by Martin Mares <mj@atrey.karlin.mff.cuni.cz>, July 1998
  *
  * Removed old-style timers, introduced console_timer, made timer
- * deletion SMP-safe.  17Jun00, Andrew Morton <andrewm@uow.edu.au>
+ * deletion SMP-safe.  17Jun00, Andrew Morton
  *
  * Removed console_lock, enabled interrupts across all console operations
  * 13 March 2001, Andrew Morton
diff -puN drivers/net/3c509.c~remove-andrew-mortons-old-email-accounts-fix drivers/net/3c509.c
--- a/drivers/net/3c509.c~remove-andrew-mortons-old-email-accounts-fix
+++ a/drivers/net/3c509.c
@@ -40,7 +40,7 @@
 		v1.14 10/15/97 Avoided waiting..discard message for fast machines -djb
 		v1.15 1/31/98 Faster recovery for Tx errors. -djb
 		v1.16 2/3/98 Different ID port handling to avoid sound cards. -djb
-		v1.18 12Mar2001 Andrew Morton <andrewm@uow.edu.au>
+		v1.18 12Mar2001 Andrew Morton
 			- Avoid bogus detect of 3c590's (Andrzej Krzysztofowicz)
 			- Reviewed against 1.18 from scyld.com
 		v1.18a 17Nov2001 Jeff Garzik <jgarzik@pobox.com>
diff -puN drivers/net/cs89x0.c~remove-andrew-mortons-old-email-accounts-fix drivers/net/cs89x0.c
--- a/drivers/net/cs89x0.c~remove-andrew-mortons-old-email-accounts-fix
+++ a/drivers/net/cs89x0.c
@@ -36,8 +36,7 @@
 
   Alan Cox          : Removed 1.2 support, added 2.1 extra counters.
 
-  Andrew Morton     : andrewm@uow.edu.au
-                    : Kernel 2.3.48
+  Andrew Morton     : Kernel 2.3.48
                     : Handle kmalloc() failures
                     : Other resource allocation fixes
                     : Add SMP locks
@@ -49,7 +48,7 @@
                     : Fixed an out-of-mem bug in dma_rx()
                     : Updated Documentation/networking/cs89x0.txt
 
-  Andrew Morton     : andrewm@uow.edu.au / Kernel 2.3.99-pre1
+  Andrew Morton     : Kernel 2.3.99-pre1
                     : Use skb_reserve to longword align IP header (two places)
                     : Remove a delay loop from dma_rx()
                     : Replace '100' with HZ
@@ -57,11 +56,11 @@
                     : Added 'cs89x0_dma=N' kernel boot option
                     : Correctly initialise lp->lock in non-module compile
 
-  Andrew Morton     : andrewm@uow.edu.au / Kernel 2.3.99-pre4-1
+  Andrew Morton     : Kernel 2.3.99-pre4-1
                     : MOD_INC/DEC race fix (see
                     : http://www.uwsg.indiana.edu/hypermail/linux/kernel/0003.3/1532.html)
 
-  Andrew Morton     : andrewm@uow.edu.au / Kernel 2.4.0-test7-pre2
+  Andrew Morton     : Kernel 2.4.0-test7-pre2
                     : Enhanced EEPROM support to cover more devices,
                     :   abstracted IRQ mapping to support CONFIG_ARCH_CLPS7500 arch
                     :   (Jason Gunthorpe <jgg@ualberta.ca>)
@@ -156,7 +155,7 @@
 #include "cs89x0.h"
 
 static char version[] __initdata =
-"cs89x0.c: v2.4.3-pre1 Russell Nelson <nelson@crynwr.com>, Andrew Morton <andrewm@uow.edu.au>\n";
+"cs89x0.c: v2.4.3-pre1 Russell Nelson <nelson@crynwr.com>, Andrew Morton\n";
 
 #define DRV_NAME "cs89x0"
 
@@ -1877,7 +1876,7 @@ MODULE_PARM_DESC(dmasize , "(ignored)");
 MODULE_PARM_DESC(use_dma , "(ignored)");
 #endif
 
-MODULE_AUTHOR("Mike Cruse, Russwll Nelson <nelson@crynwr.com>, Andrew Morton <andrewm@uow.edu.au>");
+MODULE_AUTHOR("Mike Cruse, Russwll Nelson <nelson@crynwr.com>, Andrew Morton");
 MODULE_LICENSE("GPL");
 
 
diff -puN drivers/parport/ChangeLog~remove-andrew-mortons-old-email-accounts-fix drivers/parport/ChangeLog
--- a/drivers/parport/ChangeLog~remove-andrew-mortons-old-email-accounts-fix
+++ a/drivers/parport/ChangeLog
@@ -311,7 +311,7 @@
 	* ieee1284_ops.c (parport_ieee1284_read_nibble): Reset nAutoFd
 	on timeout.  Matches 2.2.x behaviour.
 
-2001-03-02  Andrew Morton <andrewm@uow.edu.au>
+2001-03-02  Andrew Morton
 
 	* parport_pc.c (registered_parport): New static variable.
 	(parport_pc_find_ports): Set it when we register PCI driver.
diff -puN kernel/printk.c~remove-andrew-mortons-old-email-accounts-fix kernel/printk.c
--- a/kernel/printk.c~remove-andrew-mortons-old-email-accounts-fix
+++ a/kernel/printk.c
@@ -13,7 +13,7 @@
  * Fixed SMP synchronization, 08/08/99, Manfred Spraul
  *     manfred@colorfullife.com
  * Rewrote bits to get rid of console_lock
- *	01Mar01 Andrew Morton <andrewm@uow.edu.au>
+ *	01Mar01 Andrew Morton
  */
 
 #include <linux/kernel.h>
diff -puN kernel/workqueue.c~remove-andrew-mortons-old-email-accounts-fix kernel/workqueue.c
--- a/kernel/workqueue.c~remove-andrew-mortons-old-email-accounts-fix
+++ a/kernel/workqueue.c
@@ -9,7 +9,7 @@
  * Derived from the taskqueue/keventd code by:
  *
  *   David Woodhouse <dwmw2@infradead.org>
- *   Andrew Morton <andrewm@uow.edu.au>
+ *   Andrew Morton
  *   Kai Petzke <wpp@marie.physik.tu-berlin.de>
  *   Theodore Ts'o <tytso@mit.edu>
  *
_

Patches currently in -mm which might be from francois.cami@free.fr are

remove-andrew-mortons-old-email-accounts.patch
remove-andrew-mortons-old-email-accounts-fix.patch
remove-andrew-mortons-http-wwwzipcomau-akpm.patch

