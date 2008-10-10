From: akpm@linux-foundation.org
Subject: + remove-andrew-mortons-old-email-accounts.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:08:52 -0700
Message-ID: <200810102008.m9AK8qet029616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760458AbYJJUJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: francois.cami@free.fr


The patch titled
     Remove Andrew Morton's old email accounts
has been added to the -mm tree.  Its filename is
     remove-andrew-mortons-old-email-accounts.patch

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
Subject: Remove Andrew Morton's old email accounts
From: FD Cami <francois.cami@free.fr>

People can use the real name an an index into MAINTAINERS to find the
current email address.

Signed-off-by: Francois Cami <francois.cami@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SAK.txt                 |    2 +-
 Documentation/SubmittingDrivers       |    2 +-
 Documentation/networking/cs89x0.txt   |    2 +-
 Documentation/networking/vortex.txt   |    2 +-
 Documentation/scsi/ChangeLog.megaraid |    6 +++---
 fs/direct-io.c                        |    4 ++--
 fs/fs-writeback.c                     |    2 +-
 fs/mpage.c                            |    2 +-
 include/linux/journal-head.h          |    2 +-
 include/linux/task_io_accounting.h    |    2 +-
 mm/fadvise.c                          |    2 +-
 mm/page-writeback.c                   |    2 +-
 mm/pdflush.c                          |    2 +-
 mm/readahead.c                        |    2 +-
 mm/truncate.c                         |    2 +-
 15 files changed, 18 insertions(+), 18 deletions(-)

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
@@ -690,7 +690,7 @@ latest drivers and technical publication
 6.4 Current maintainer
 
 In February 2000 the maintenance of this driver was assumed by Andrew
-Morton <akpm@zip.com.au>
+Morton.
 
 6.5 Kernel module parameters
 
diff -puN Documentation/networking/vortex.txt~remove-andrew-mortons-old-email-accounts Documentation/networking/vortex.txt
--- a/Documentation/networking/vortex.txt~remove-andrew-mortons-old-email-accounts
+++ a/Documentation/networking/vortex.txt
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

remove-andrew-mortons-old-email-accounts.patch

