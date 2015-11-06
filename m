From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:25 -0800
Message-ID: <563d0ad5.y92foxkaRpjFMETR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162871AbbKFURZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove refresh_cpu_vm_stats() definition for !SMP kernel
has been removed from the -mm tree.  Its filename was
     mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: remove refresh_cpu_vm_stats() definition for !SMP kernel

refresh_cpu_vm_stats(int cpu) is no longer referenced by !SMP kernel
since Linux 3.12.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/vmstat.h~mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-remove-refresh_cpu_vm_stats-definition-for-smp-kernel
+++ a/include/linux/vmstat.h
@@ -247,7 +247,6 @@ static inline void __dec_zone_page_state
 
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
-static inline void refresh_cpu_vm_stats(int cpu) { }
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


