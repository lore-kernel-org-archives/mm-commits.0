From: akpm@linux-foundation.org
Subject: - fix-typo-in-tick-broadcastc.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:31 -0700
Message-ID: <200804261640.m3QGeVTA031040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894AbYDZQl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     fix typo in tick-broadcast.c
has been removed from the -mm tree.  Its filename was
     fix-typo-in-tick-broadcastc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix typo in tick-broadcast.c
From: Glauber Costa <gcosta@redhat.com>

braodcast -> broadcast

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-broadcast.c~fix-typo-in-tick-broadcastc kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~fix-typo-in-tick-broadcastc
+++ a/kernel/time/tick-broadcast.c
@@ -262,7 +262,7 @@ out:
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	if (!cpu_isset(*oncpu, cpu_online_map))
-		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
+		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
 		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
_

Patches currently in -mm which might be from gcosta@redhat.com are

origin.patch
git-hrt.patch
git-kvm.patch

