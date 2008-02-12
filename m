From: akpm@linux-foundation.org
Subject: - softlockup-debug2.patch removed from -mm tree
Date: Tue, 12 Feb 2008 12:48:57 -0800
Message-ID: <200802122057.m1CKvt8M021827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbYBLU6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 15:58:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup debug
has been removed from the -mm tree.  Its filename was
     softlockup-debug2.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: softlockup debug
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/softlockup.c~softlockup-debug2 kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-debug2
+++ a/kernel/softlockup.c
@@ -236,6 +236,7 @@ static int watchdog(void *__bind_cpu)
 			check_hung_uninterruptible_tasks(this_cpu);
 
 	}
+	printk(KERN_ERR "watchdog(cpu: %d) -- exit\n", this_cpu);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

origin.patch
softlockup-workaround.patch
softlockup-debug2.patch
