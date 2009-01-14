From: akpm@linux-foundation.org
Subject: [failures] rtc-cumulative-style-fixes-fix-fix.patch removed from -mm tree
Date: Wed, 14 Jan 2009 10:36:01 -0800
Message-ID: <200901141836.n0EIa1o8030064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZANSg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 13:36:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-cumulative-style-fixes-fix-fix
has been removed from the -mm tree.  Its filename was
     rtc-cumulative-style-fixes-fix-fix.patch

This patch was dropped because it had testing failures

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

cgroups-consolidate-cgroup-documents.patch
memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch
memcg-fix-error-path-of-mem_cgroup_move_parent.patch
memcg-fix-hierarchical-reclaim.patch
memcg-make-oom-less-frequently.patch
rtc-cumulative-style-fixes-fix-fix.patch

