From: akpm@linux-foundation.org
Subject: + whitespace-fixes-dma-channel-allocator.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:46 -0700
Message-ID: <200707210018.l6L0IkBF023864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758720AbXGUAUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     whitespace fixes: DMA channel allocator
has been added to the -mm tree.  Its filename is
     whitespace-fixes-dma-channel-allocator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: DMA channel allocator
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/dma.c~whitespace-fixes-dma-channel-allocator kernel/dma.c
--- a/kernel/dma.c~whitespace-fixes-dma-channel-allocator
+++ a/kernel/dma.c
@@ -20,7 +20,7 @@
 #include <asm/dma.h>
 #include <asm/system.h>
 
- 
+
 
 /* A note on resource allocation:
  *
@@ -95,7 +95,7 @@ void free_dma(unsigned int dmanr)
 	if (xchg(&dma_chan_busy[dmanr].lock, 0) == 0) {
 		printk(KERN_WARNING "Trying to free free DMA%d\n", dmanr);
 		return;
-	}	
+	}
 
 } /* free_dma */
 
@@ -121,8 +121,8 @@ static int proc_dma_show(struct seq_file
 
 	for (i = 0 ; i < MAX_DMA_CHANNELS ; i++) {
 		if (dma_chan_busy[i].lock) {
-		    seq_printf(m, "%2d: %s\n", i,
-			       dma_chan_busy[i].device_id);
+			seq_printf(m, "%2d: %s\n", i,
+				   dma_chan_busy[i].device_id);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
