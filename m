From: akpm@linux-foundation.org
Subject: + timer_list-split-timer_list_show_tickdevices-v4.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:55:29 -0800
Message-ID: <20130228215529.81A575A41DD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43822 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3B1Vza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:55:30 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so258841ghb.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:55:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, sboyd@codeaurora.org, tglx@linutronix.de


The patch titled
     Subject: timer_list-split-timer_list_show_tickdevices-v4
has been added to the -mm tree.  Its filename is
     timer_list-split-timer_list_show_tickdevices-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: timer_list-split-timer_list_show_tickdevices-v4

v4: correct extra whitespace

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/time/timer_list.c~timer_list-split-timer_list_show_tickdevices-v4 kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-split-timer_list_show_tickdevices-v4
+++ a/kernel/time/timer_list.c
@@ -244,7 +244,6 @@ static void timer_list_show_tickdevices_
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	SEQ_printf(m, "\n");
 }
 #endif
 
_

Patches currently in -mm which might be from nzimmer@sgi.com are

origin.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
procfs-improve-scaling-in-proc.patch

