From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
 removed from -mm tree
Date: Mon, 07 Apr 2014 15:09:02 -0700
Message-ID: <534321fe.6tZKUtKioY6NZlLW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaDGWJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, minchan@kernel.org, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, gioh.kim@lge.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-vmallocc-enhance-vm_map_ram-comment-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,gioh.kim@lge.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,minchan@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:09:02 -0700


The patch titled
     Subject: mm-vmallocc-enhance-vm_map_ram-comment-fix
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-enhance-vm_map_ram-comment-fix.patch

This patch was dropped because it was folded into mm-vmallocc-enhance-vm_map_ram-comment.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmallocc-enhance-vm_map_ram-comment-fix

tweak comment text

Cc: "Gioh Kim" <gioh.kim@lge.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-enhance-vm_map_ram-comment-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-enhance-vm_map_ram-comment-fix
+++ a/mm/vmalloc.c
@@ -1085,11 +1085,11 @@ EXPORT_SYMBOL(vm_unmap_ram);
  * @node: prefer to allocate data structures on this node
  * @prot: memory protection to use. PAGE_KERNEL for regular RAM
  *
- * If you use this function for below VMAP_MAX_ALLOC pages, it could be faster
- * than vmap so it's good. But if you mix long-life and short-life object
- * with vm_map_ram, it could consume lots of address space by fragmentation
- * (expecially, 32bit machine). You could see failure in the end.
- * Please use this function for short-life object.
+ * If you use this function for less than VMAP_MAX_ALLOC pages, it could be
+ * faster than vmap so it's good.  But if you mix long-life and short-life
+ * objects with vm_map_ram(), it could consume lots of address space through
+ * fragmentation (especially on a 32bit machine).  You could see failures in
+ * the end.  Please use this function for short-lived objects.
  *
  * Returns: a pointer to the address that has been mapped, or %NULL on failure
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

