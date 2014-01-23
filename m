From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
 removed from -mm tree
Date: Thu, 23 Jan 2014 15:18:33 -0800
Message-ID: <52e1a349.0nAcW/fClPs+BX7L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAWXSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org,vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:18:33 -0800


The patch titled
     Subject: memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix
has been removed from the -mm tree.  Its filename was
     memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch

This patch was dropped because it was folded into memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix

fix build

Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix
+++ a/include/linux/memcontrol.h
@@ -647,7 +647,7 @@ static inline int memcg_alloc_cache_para
 	return 0;
 }
 
-static inline void memcg_free_cache_params(struct kmem_cache *s);
+static inline void memcg_free_cache_params(struct kmem_cache *s)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

