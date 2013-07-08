From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 15:28:02 -0700
Message-ID: <51db3cf2.DRQnEfu8hT74ftdU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHW2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, lizefan@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, akpm@linux-foundation.org

Subject: [folded-merged] memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,lizefan@huawei.com,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:28:02 -0700


The patch titled
     Subject: memcg-use-css_get-put-when-charging-uncharging-kmem-fix
has been removed from the -mm tree.  Its filename was
     memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch

This patch was dropped because it was folded into memcg-use-css_get-put-when-charging-uncharging-kmem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-use-css_get-put-when-charging-uncharging-kmem-fix

tweak comment

Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem-fix
+++ a/mm/memcontrol.c
@@ -407,7 +407,7 @@ static void memcg_kmem_clear_activated(s
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
 	/*
-	 * We need to call css_get() first, because memcg_uncharge_kmem()
+	 * Our caller must use css_get() first, because memcg_uncharge_kmem()
 	 * will call css_put() if it sees the memcg is dead.
 	 */
 	smp_wmb();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

