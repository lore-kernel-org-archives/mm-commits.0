From: akpm@linux-foundation.org
Subject: + timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch added to -mm tree
Date: Thu, 21 Feb 2013 15:09:24 -0800
Message-ID: <20130221230924.997A631C042@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:42832 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3BUXJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:09:26 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so9720qeb.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:09:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@redhat.com, johnstul@us.ibm.com, nzimmer@sgi.com, tglx@linutronix.de


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
has been added to the -mm tree.  Its filename is
     timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch

