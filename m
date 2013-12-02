From: akpm@linux-foundation.org
Subject: +
 kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch added to
 -mm tree
Date: Mon, 02 Dec 2013 15:22:01 -0800
Message-ID: <529d1619.n2KRp9FIgfWHT/Mn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3LBXWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 18:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wangyijing@huawei.com

Subject: + kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch added to -mm tree
To: wangyijing@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 15:22:01 -0800


The patch titled
     Subject: kernel/time/timekeeping.c: fix comment for tk_setup_internals()
has been added to the -mm tree.  Its filename is
     kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-time-timekeepingc-fix-comment-for-tk_setup_internals.patch

