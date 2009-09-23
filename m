From: akpm@linux-foundation.org
Subject: [merged] rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:58 -0700
Message-ID: <200909231958.n8NJwwMA010023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798AbZIWT7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: update documentation wrt RTC_PIE/irq_set_state
has been removed from the -mm tree.  Its filename was
     rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: update documentation wrt RTC_PIE/irq_set_state
From: Mike Frysinger <vapier@gentoo.org>


Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/rtc.txt~rtc-update-documentation-wrt-rtc_pie-irq_set_state Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-update-documentation-wrt-rtc_pie-irq_set_state
+++ a/Documentation/rtc.txt
@@ -185,6 +185,8 @@ driver returns ENOIOCTLCMD.  Some common
 	hardware in the irq_set_freq function.  If it isn't, return -EINVAL.  If
 	you cannot actually change the frequency, do not define irq_set_freq.
 
+    *	RTC_PIE_ON, RTC_PIE_OFF: the irq_set_state function will be called.
+
 If all else fails, check out the rtc-test.c driver!
 
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

