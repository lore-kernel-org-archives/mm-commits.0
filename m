From: akpm@linux-foundation.org
Subject: - remove-andrew-mortons-old-email-accounts.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:22 -0700
Message-ID: <200810182312.m9INCMOU027974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbYJRXM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: francois.cami@free.fr, mm-commits@vger.kernel.org


The patch titled
     Remove Andrew Morton's old email accounts
has been removed from the -mm tree.  Its filename was
     remove-andrew-mortons-old-email-accounts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove Andrew Morton's old email accounts
From: Francois Cami <francois.cami@free.fr>

People can use the real name an an index into MAINTAINERS to find the
current email address.

Signed-off-by: Francois Cami <francois.cami@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SAK.txt                 |    2 +-
 Documentation/SubmittingDrivers       |    2 +-
 Documentation/networking/cs89x0.txt   |    4 ++--
 Documentation/networking/vortex.txt   |    4 ++--
 Documentation/scsi/ChangeLog.megaraid |    6 +++---
 drivers/char/vt.c                     |    2 +-
 drivers/net/3c509.c                   |    2 +-
 drivers/net/cs89x0.c                  |   13 ++++++-------
 drivers/parport/ChangeLog             |    2 +-
 fs/direct-io.c                        |    4 ++--
 fs/fs-writeback.c                     |    2 +-
 fs/mpage.c                            |    2 +-
 include/linux/journal-head.h          |    2 +-
 include/linux/task_io_accounting.h    |    2 +-
 kernel/printk.c                       |    2 +-
 kernel/workqueue.c                    |    2 +-
 mm/fadvise.c                          |    2 +-
 mm/page-writeback.c                   |    2 +-
 mm/pdflush.c                          |    2 +-
 mm/readahead.c                        |    2 +-
 mm/truncate.c                         |    2 +-
 21 files changed, 31 insertions(+), 32 deletions(-)

diff -puN Documentation/SAK.txt~remove-andrew-mortons-old-email-accounts Documentation/SAK.txt
--- a/Documentation/SAK.txt~remove-andrew-mortons-old-email-accounts
+++ a/Documentation/SAK.txt
@@ -1,5 +1,5 @@
 Linux 2.4.2 Secure Attention Key (SAK) handling
-18 March 2001, Andrew Morton <akpm@osdl.org>
+18 March 2001, Andrew Morton
 
 An operating system's Secure Attention Key is a security tool which is
 provided as protection against trojan password capturing programs.  It
diff -puN Documentation/SubmittingDrivers~remove-andrew-mortons-old-email-accounts Documentation/SubmittingDrivers
--- a/Documentation/SubmittingDrivers~remove-andrew-mortons-old-email-accounts
+++ a/Documentation/SubmittingDrivers
@@ -41,7 +41,7 @@ Linux 2.4:
 Linux 2.6:
 	The same rules apply as 2.4 except that you should follow linux-kernel
 	to track changes in API's. The final contact point for Linux 2.6
-	submissions is Andrew Morton <akpm@osdl.org>.
+	submissions is Andrew Morton.
 
 What Criteria Determine Acceptance
 ----------------------------------
diff -puN Documentation/networking/cs89x0.txt~remove-andrew-mortons-old-email-accounts Documentation/networking/cs89x0.txt
--- a/Documentation/networking/cs89x0.txt~remove-andrew-mortons-old-email-accounts
+++ a/Documentation/networking/cs89x0.txt
@@ -3,7 +3,7 @@ NOTE
 ----
 
 This document was contributed by Cirrus Logic for kernel 2.2.5.  This version
-has been updated for 2.3.48 by Andrew Morton <andrewm@uow.edu.au>
+has been updated for 2.3.48 by Andrew Morton.
 
 Cirrus make a copy of this driver available at their website, as
 described below.  In general, you should use the driver version which
@@ -690,7 +690,7 @@ latest drivers and technical publication
 6.4 Current maintainer
 
 In February 2000 the maintenance of this driver was assumed by Andrew
-Morton <akpm@zip.com.au>
+Morton.
 
 6.5 Kernel module parameters
 
diff -puN Documentation/networking/vortex.txt~remove-andrew-mortons-old-email-accounts Documentation/networking/vortex.txt
--- a/Documentation/networking/vortex.txt~remove-andrew-mortons-old-email-accounts
+++ a/Documentation/networking/vortex.txt
@@ -1,5 +1,5 @@
 Documentation/networking/vortex.txt
-Andrew Morton <andrewm@uow.edu.au>
+Andrew Morton
 30 April 2000
 
 
@@ -11,7 +11,7 @@ The driver was written by Donald Becker 
 Don is no longer the prime maintainer of this version of the driver. 
 Please report problems to one or more of:
 
-  Andrew Morton <akpm@osdl.org>
+  Andrew Morton
   Netdev mailing list <netdev@vger.kernel.org>
   Linux kernel mailing list <linux-kernel@vger.kernel.org>
 
diff -puN Documentation/scsi/ChangeLog.megaraid~remove-andrew-mortons-old-email-accounts Documentation/scsi/ChangeLog.megaraid
--- a/Documentation/scsi/ChangeLog.megaraid~remove-andrew-mortons-old-email-accounts
+++ a/Documentation/scsi/ChangeLog.megaraid
@@ -409,7 +409,7 @@ i.	Function reordering so that inline fu
 	megaraid_mbox_prepare_pthru, megaraid_mbox_prepare_epthru,
 	megaraid_busywait_mbox
 
-		- Andrew Morton <akpm@osdl.org>, 08.19.2004
+		- Andrew Morton, 08.19.2004
 		linux-scsi mailing list
 
 	"Something else to clean up after inclusion: every instance of an
@@ -471,13 +471,13 @@ vi.	Add support for 64-bit applications.
 vii.	Move the function declarations for the management module from
 	megaraid_mm.h to megaraid_mm.c
 
-		- Andrew Morton <akpm@osdl.org>, 08.19.2004
+		- Andrew Morton, 08.19.2004
 		linux-scsi mailing list
 
 viii.	Change default values for MEGARAID_NEWGEN, MEGARAID_MM, and
 	MEGARAID_MAILBOX to 'n' in Kconfig.megaraid
 
-		- Andrew Morton <akpm@osdl.org>, 08.19.2004
+		- Andrew Morton, 08.19.2004
 		linux-scsi mailing list
 
 ix.	replace udelay with msleep
diff -puN drivers/char/vt.c~remove-andrew-mortons-old-email-accounts drivers/char/vt.c
--- a/drivers/char/vt.c~remove-andrew-mortons-old-email-accounts
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
diff -puN drivers/net/3c509.c~remove-andrew-mortons-old-email-accounts drivers/net/3c509.c
--- a/drivers/net/3c509.c~remove-andrew-mortons-old-email-accounts
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
diff -puN drivers/net/cs89x0.c~remove-andrew-mortons-old-email-accounts drivers/net/cs89x0.c
--- a/drivers/net/cs89x0.c~remove-andrew-mortons-old-email-accounts
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
 
 
diff -puN drivers/parport/ChangeLog~remove-andrew-mortons-old-email-accounts drivers/parport/ChangeLog
--- a/drivers/parport/ChangeLog~remove-andrew-mortons-old-email-accounts
+++ a/drivers/parport/ChangeLog
@@ -311,7 +311,7 @@
 	* ieee1284_ops.c (parport_ieee1284_read_nibble): Reset nAutoFd
 	on timeout.  Matches 2.2.x behaviour.
 
-2001-03-02  Andrew Morton <andrewm@uow.edu.au>
+2001-03-02  Andrew Morton
 
 	* parport_pc.c (registered_parport): New static variable.
 	(parport_pc_find_ports): Set it when we register PCI driver.
diff -puN fs/direct-io.c~remove-andrew-mortons-old-email-accounts fs/direct-io.c
--- a/fs/direct-io.c~remove-andrew-mortons-old-email-accounts
+++ a/fs/direct-io.c
@@ -5,11 +5,11 @@
  *
  * O_DIRECT
  *
- * 04Jul2002	akpm@zip.com.au
+ * 04Jul2002	Andrew Morton
  *		Initial version
  * 11Sep2002	janetinc@us.ibm.com
  * 		added readv/writev support.
- * 29Oct2002	akpm@zip.com.au
+ * 29Oct2002	Andrew Morton
  *		rewrote bio_add_page() support.
  * 30Oct2002	pbadari@us.ibm.com
  *		added support for non-aligned IO.
diff -puN fs/fs-writeback.c~remove-andrew-mortons-old-email-accounts fs/fs-writeback.c
--- a/fs/fs-writeback.c~remove-andrew-mortons-old-email-accounts
+++ a/fs/fs-writeback.c
@@ -8,7 +8,7 @@
  * pages against inodes.  ie: data writeback.  Writeout of the
  * inode itself is not handled here.
  *
- * 10Apr2002	akpm@zip.com.au
+ * 10Apr2002	Andrew Morton
  *		Split out of fs/inode.c
  *		Additions for address_space-based writeback
  */
diff -puN fs/mpage.c~remove-andrew-mortons-old-email-accounts fs/mpage.c
--- a/fs/mpage.c~remove-andrew-mortons-old-email-accounts
+++ a/fs/mpage.c
@@ -6,7 +6,7 @@
  * Contains functions related to preparing and submitting BIOs which contain
  * multiple pagecache pages.
  *
- * 15May2002	akpm@zip.com.au
+ * 15May2002	Andrew Morton
  *		Initial version
  * 27Jun2002	axboe@suse.de
  *		use bio_add_page() to build bio's just the right size
diff -puN include/linux/journal-head.h~remove-andrew-mortons-old-email-accounts include/linux/journal-head.h
--- a/include/linux/journal-head.h~remove-andrew-mortons-old-email-accounts
+++ a/include/linux/journal-head.h
@@ -3,7 +3,7 @@
  *
  * buffer_head fields for JBD
  *
- * 27 May 2001 Andrew Morton <akpm@digeo.com>
+ * 27 May 2001 Andrew Morton
  *	Created - pulled out of fs.h
  */
 
diff -puN include/linux/task_io_accounting.h~remove-andrew-mortons-old-email-accounts include/linux/task_io_accounting.h
--- a/include/linux/task_io_accounting.h~remove-andrew-mortons-old-email-accounts
+++ a/include/linux/task_io_accounting.h
@@ -5,7 +5,7 @@
  * Don't include this header file directly - it is designed to be dragged in via
  * sched.h.
  *
- * Blame akpm@osdl.org for all this.
+ * Blame Andrew Morton for all this.
  */
 
 struct task_io_accounting {
diff -puN kernel/printk.c~remove-andrew-mortons-old-email-accounts kernel/printk.c
--- a/kernel/printk.c~remove-andrew-mortons-old-email-accounts
+++ a/kernel/printk.c
@@ -13,7 +13,7 @@
  * Fixed SMP synchronization, 08/08/99, Manfred Spraul
  *     manfred@colorfullife.com
  * Rewrote bits to get rid of console_lock
- *	01Mar01 Andrew Morton <andrewm@uow.edu.au>
+ *	01Mar01 Andrew Morton
  */
 
 #include <linux/kernel.h>
diff -puN kernel/workqueue.c~remove-andrew-mortons-old-email-accounts kernel/workqueue.c
--- a/kernel/workqueue.c~remove-andrew-mortons-old-email-accounts
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
diff -puN mm/fadvise.c~remove-andrew-mortons-old-email-accounts mm/fadvise.c
--- a/mm/fadvise.c~remove-andrew-mortons-old-email-accounts
+++ a/mm/fadvise.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds
  *
- * 11Jan2003	akpm@digeo.com
+ * 11Jan2003	Andrew Morton
  *		Initial version.
  */
 
diff -puN mm/page-writeback.c~remove-andrew-mortons-old-email-accounts mm/page-writeback.c
--- a/mm/page-writeback.c~remove-andrew-mortons-old-email-accounts
+++ a/mm/page-writeback.c
@@ -7,7 +7,7 @@
  * Contains functions related to writing back dirty pages at the
  * address_space level.
  *
- * 10Apr2002	akpm@zip.com.au
+ * 10Apr2002	Andrew Morton
  *		Initial version
  */
 
diff -puN mm/pdflush.c~remove-andrew-mortons-old-email-accounts mm/pdflush.c
--- a/mm/pdflush.c~remove-andrew-mortons-old-email-accounts
+++ a/mm/pdflush.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds.
  *
- * 09Apr2002	akpm@zip.com.au
+ * 09Apr2002	Andrew Morton
  *		Initial version
  * 29Feb2004	kaos@sgi.com
  *		Move worker thread creation to kthread to avoid chewing
diff -puN mm/readahead.c~remove-andrew-mortons-old-email-accounts mm/readahead.c
--- a/mm/readahead.c~remove-andrew-mortons-old-email-accounts
+++ a/mm/readahead.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds
  *
- * 09Apr2002	akpm@zip.com.au
+ * 09Apr2002	Andrew Morton
  *		Initial version.
  */
 
diff -puN mm/truncate.c~remove-andrew-mortons-old-email-accounts mm/truncate.c
--- a/mm/truncate.c~remove-andrew-mortons-old-email-accounts
+++ a/mm/truncate.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, Linus Torvalds
  *
- * 10Sep2002	akpm@zip.com.au
+ * 10Sep2002	Andrew Morton
  *		Initial version.
  */
 
_

Patches currently in -mm which might be from francois.cami@free.fr are

origin.patch

