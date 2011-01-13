From: akpm@linux-foundation.org
Subject: [merged] rtc-delete-legacy-maintainers-entry.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:24 -0800
Message-ID: <201101132010.p0DKA5QA030024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933663Ab1AMUKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: delete legacy MAINTAINERS entry
has been removed from the -mm tree.  Its filename was
     rtc-delete-legacy-maintainers-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5131,11 +5131,6 @@ F:	kernel/rcu*
 F:	kernel/srcu*
 X:	kernel/rcutorture.c
 
-REAL TIME CLOCK DRIVER (LEGACY)
-M:	Paul Gortmaker <p_gortmaker@yahoo.com>
-S:	Maintained
-F:	drivers/char/rtc.c
