From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:09:31 -0800
Message-ID: <20130221230932.2491231C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:35569 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:09:34 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so9879vbb.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:09:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, johnstul@us.ibm.com, nzimmer@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch

This patch was dropped because it was folded into timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix

fix typo in comment

Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
+++ a/kernel/time/timer_list.c
@@ -275,7 +275,7 @@ static int timer_list_show(struct seq_fi
 }
 
 /*
- * This itererator really needs some explnation since it is offset and has
+ * This itererator really needs some explanation since it is offset and has
  * two passes, one of which is controlled by a config option.
  * In a hotplugged system some cpus, including cpu 0, may be missing so we have
  * to use cpumask_* to iterate over the cpus.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

