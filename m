From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:16:43 -0800
Message-ID: <5488d45b.eewu/5ljdOE5BF5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbaLJXQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch

This patch was dropped because it was folded into mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix

remove unneeded initialization of `memcg', per Michal

Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix
+++ a/mm/memcontrol.c
@@ -2523,7 +2523,7 @@ static struct mem_cgroup *mem_cgroup_loo
  */
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
-	struct mem_cgroup *memcg = NULL;
+	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
 	unsigned short id;
 	swp_entry_t ent;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
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

