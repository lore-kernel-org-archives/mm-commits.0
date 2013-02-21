From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:07:38 -0800
Message-ID: <20130221230738.E06A131C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:47916 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:07:40 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so24819qah.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:07:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, johnstul@us.ibm.com, nzimmer@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch

This patch was dropped because it was folded into timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix

fix up comment

Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix
+++ a/kernel/time/timer_list.c
@@ -275,8 +275,8 @@ static int timer_list_show(struct seq_fi
 }
 
 /*
- * This itererator really needs some explination since it is offset and has
- * two passes one of which is controlled by a config option.
+ * This itererator really needs some explnation since it is offset and has
+ * two passes, one of which is controlled by a config option.
  * In a hotplugged system some cpus, including cpu 0, may be missing so we have
  * to use cpumask_* to iterate over the cpus.
  * For the first pass:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch

