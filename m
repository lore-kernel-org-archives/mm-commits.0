From: akpm@linux-foundation.org
Subject: - gru-driver-v2-driver-makefile.patch removed from -mm tree
Date: Tue, 01 Jul 2008 01:04:21 -0700
Message-ID: <200807010804.m6184LWI016398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228AbYGAIEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     GRU driver: driver makefile
has been removed from the -mm tree.  Its filename was
     gru-driver-v2-driver-makefile.patch

This patch was dropped because it needs mmu notifiers, which I don't have

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

gru-driver-v2-driver-makefile.patch
gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

