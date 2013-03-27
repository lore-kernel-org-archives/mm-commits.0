From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-split-timer_list_show_tickdevices-v4.patch removed from -mm tree
Date: Wed, 27 Mar 2013 12:07:30 -0700
Message-ID: <20130327190731.3E12C31C166@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:64667 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3C0THc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 15:07:32 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so568507qeb.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 12:07:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, davej@redhat.com, johnstul@us.ibm.com, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-split-timer_list_show_tickdevices-v4
has been removed from the -mm tree.  Its filename was
     timer_list-split-timer_list_show_tickdevices-v4.patch

This patch was dropped because it was folded into timer_list-split-timer_list_show_tickdevices.patch

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

linux-next.patch
sound-convert-snd_info_register-to-use-proc_create_data.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
procfs-improve-scaling-in-proc.patch
procfs-improve-scaling-in-proc-v5.patch

