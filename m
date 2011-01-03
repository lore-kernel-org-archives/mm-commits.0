From: akpm@linux-foundation.org
Subject: + rtc-delete-legacy-maintainers-entry.patch added to -mm tree
Date: Mon, 03 Jan 2011 11:58:41 -0800
Message-ID: <201101031958.p03JwfsI025705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab1ACT6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 14:58:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.gortmaker@windriver.com, a.zummo@towertech.it


The patch titled
     rtc: delete legacy MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     rtc-delete-legacy-maintainers-entry.patch

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
Subject: rtc: delete legacy MAINTAINERS entry
From: Paul Gortmaker <paul.gortmaker@windriver.com>

People stumble across the entry for the legacy PC specific RTC driver
entry in MAINTAINERS when they really want the multi-arch, multi-driver
RTC subsystem.  So just delete the old entry that is causing the
confusion.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~rtc-delete-legacy-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~rtc-delete-legacy-maintainers-entry
+++ a/MAINTAINERS
@@ -5065,11 +5065,6 @@ F:	kernel/rcu*
 F:	kernel/srcu*
 X:	kernel/rcutorture.c
 
-REAL TIME CLOCK DRIVER (LEGACY)
-M:	Paul Gortmaker <p_gortmaker@yahoo.com>
-S:	Maintained
-F:	drivers/char/rtc.c
