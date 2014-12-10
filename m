From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memcontrol-lockless-page-counters-fix.patch
 removed from -mm tree
Date: Wed, 10 Dec 2014 15:12:18 -0800
Message-ID: <5488d352.hkhRXMB2h87azja8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451AbaLJXMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-lockless-page-counters-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-lockless-page-counters-fix.patch

This patch was dropped because it was folded into mm-memcontrol-lockless-page-counters.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-lockless-page-counters-fix

add includes for WARN_ON_ONCE and memparse

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_counter.c~mm-memcontrol-lockless-page-counters-fix mm/page_counter.c
--- a/mm/page_counter.c~mm-memcontrol-lockless-page-counters-fix
+++ a/mm/page_counter.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2014 Red Hat, Inc., Johannes Weiner
  */
 
+#include <linux/kernel.h>
+#include <linux/bug.h>
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/sched.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

