From: akpm@linux-foundation.org
Subject: + rtc-cumulative-style-fixes-fix-fix.patch added to -mm tree
Date: Mon, 12 Jan 2009 22:25:36 -0800
Message-ID: <200901130625.n0D6PaHs015897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbZAMG0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 01:26:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.zummo@towertech.it


The patch titled
     rtc-cumulative-style-fixes-fix-fix
has been added to the -mm tree.  Its filename is
     rtc-cumulative-style-fixes-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cumulative-style-fixes-fix-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This was necessary for hpet* functions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cumulative-style-fixes-fix-fix drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cumulative-style-fixes-fix-fix
+++ a/drivers/rtc/rtc-cmos.c
@@ -39,6 +39,7 @@
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
+#include <asm/hpet.h>
 
 struct cmos_rtc {
 	struct rtc_device	*rtc;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

rtc-cumulative-style-fixes-fix-fix.patch

