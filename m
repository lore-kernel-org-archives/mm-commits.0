From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-res_counter-remove-the-unused-api-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:13:06 -0800
Message-ID: <5488d382.wjXO5iXqZ+q3HsQY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbaLJXNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, pebolle@tiscali.nl, rientjes@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-res_counter-remove-the-unused-api-fix
has been removed from the -mm tree.  Its filename was
     kernel-res_counter-remove-the-unused-api-fix.patch

This patch was dropped because it was folded into kernel-res_counter-remove-the-unused-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-res_counter-remove-the-unused-api-fix

update Documentation/cgroups/memory.txt

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/memory.txt~kernel-res_counter-remove-the-unused-api-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~kernel-res_counter-remove-the-unused-api-fix
+++ a/Documentation/cgroups/memory.txt
@@ -352,9 +352,8 @@ set:
 0. Configuration
 
 a. Enable CONFIG_CGROUPS
-b. Enable CONFIG_RESOURCE_COUNTERS
-c. Enable CONFIG_MEMCG
-d. Enable CONFIG_MEMCG_SWAP (to use swap extension)
+b. Enable CONFIG_MEMCG
+c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
 
 1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
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

