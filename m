From: akpm@linux-foundation.org
Subject: - whitespace-fixes-dma-channel-allocator.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:40 -0700
Message-ID: <200710190343.l9J3he5K013081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759257AbXJSDzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: DMA channel allocator
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-dma-channel-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: DMA channel allocator
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
