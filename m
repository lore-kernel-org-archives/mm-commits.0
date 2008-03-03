From: akpm@linux-foundation.org
Subject: + time-remove-obsolete-clock_tick_adjust-update.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:55:32 -0800
Message-ID: <200803032155.m23LtWaZ008585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbYCCV40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mattilinnanvuori@yahoo.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     time-remove-obsolete-clock_tick_adjust-update
has been added to the -mm tree.  Its filename is
     time-remove-obsolete-clock_tick_adjust-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time-remove-obsolete-clock_tick_adjust-update
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust-update kernel/time/ntp.c
--- a/kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust-update
+++ a/kernel/time/ntp.c
@@ -42,7 +42,7 @@ long time_esterror = NTP_PHASE_LIMIT;	/*
 long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
-long ntp_tick_adj;
+static long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

time-remove-obsolete-clock_tick_adjust-update.patch

