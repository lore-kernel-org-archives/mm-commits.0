From: akpm@linux-foundation.org
Subject: [merged]
 kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch removed
 from -mm tree
Date: Mon, 13 Jan 2014 13:21:52 -0800
Message-ID: <52d458f0.NVfu3lyAjsuIV1cI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaAMVVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:21:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wangyijing@huawei.com

Subject: [merged] kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch removed from -mm tree
To: wangyijing@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:21:52 -0800


The patch titled
     Subject: kernel/time/timekeeping.c: fix comment for tk_setup_internals()
has been removed from the -mm tree.  Its filename was
     kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yijing Wang <wangyijing@huawei.com>
Subject: kernel/time/timekeeping.c: fix comment for tk_setup_internals()

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/time/timekeeping.c~kernel-time-timekeepingc-fix-comment-for-tk_setup_internals kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~kernel-time-timekeepingc-fix-comment-for-tk_setup_internals
+++ a/kernel/time/timekeeping.c
@@ -90,8 +90,9 @@ static void tk_set_sleep_time(struct tim
 }
 
 /**
- * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ * tk_setup_internals - Set up internals to use clocksource clock.
  *
+ * @tk:		The target timekeeper to setup.
  * @clock:		Pointer to clocksource.
  *
  * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
_

Patches currently in -mm which might be from wangyijing@huawei.com are

linux-next.patch

