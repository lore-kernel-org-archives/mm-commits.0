From: akpm@linux-foundation.org
Subject: + gru-driver-v2-driver-makefile.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:30:47 -0700
Message-ID: <200807010530.m615UlUH010839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbYGAFb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     GRU driver: driver makefile
has been added to the -mm tree.  Its filename is
     gru-driver-v2-driver-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU driver: driver makefile
From: Jack Steiner <steiner@sgi.com>

Add the GRU driver makefile.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff -puN /dev/null drivers/misc/sgi-gru/Makefile
--- /dev/null
+++ a/drivers/misc/sgi-gru/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SGI_GRU) := gru.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-driver-v2-hardware-data-structures.patch
gru-driver-v2-gru-instructions-macros.patch
gru-driver-v2-driver-internal-header-files.patch
gru-driver-v2-kernel-services-header-files.patch
gru-driver-v2-driver-initialization-file-vma-ops.patch
gru-driver-v2-page-faults-exceptions.patch
gru-driver-v2-kernel-services-provide-by-driver.patch
gru-driver-v2-resource-management.patch
gru-driver-v2-proc-interfaces.patch
gru-driver-v2-tlb-flushing-mmuops-callouts.patch
gru-driver-v2-driver-makefile.patch
gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

