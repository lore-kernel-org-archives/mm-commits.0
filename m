From: akpm@linux-foundation.org
Subject: [folded-merged] block-prevent-race-cleanup-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:26:51 -0800
Message-ID: <20121218202651.BF030100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:57541 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2LRU0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:26:53 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so128467vba.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:26:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, dbasehore@chromium.org, msb@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block-prevent-race-cleanup-fix
has been removed from the -mm tree.  Its filename was
     block-prevent-race-cleanup-fix.patch

This patch was dropped because it was folded into block-prevent-race-cleanup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prevent-race-cleanup-fix

fix spello in comment

Cc: Derek Basehore <dbasehore@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/genhd.c~block-prevent-race-cleanup-fix block/genhd.c
--- a/block/genhd.c~block-prevent-race-cleanup-fix
+++ a/block/genhd.c
@@ -1591,7 +1591,7 @@ unsigned int disk_clear_events(struct ge
 }
 
 /*
- * Seperate this part out so that a different pointer for clearing_ptr can be
+ * Separate this part out so that a different pointer for clearing_ptr can be
  * passed in for disk_clear_events.
  */
 static void disk_events_workfn(struct work_struct *work)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch

