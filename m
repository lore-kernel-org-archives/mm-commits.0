From: akpm@linux-foundation.org
Subject: + mm-vmallocc-enhance-vm_map_ram-comment-fix.patch added to -mm
 tree
Date: Mon, 10 Mar 2014 13:29:20 -0700
Message-ID: <531e20a0.sYZn+s600DSGuKpX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaCJU3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, minchan@kernel.org, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, gioh.kim@lge.com, akpm@linux-foundation.org

Subject: + mm-vmallocc-enhance-vm_map_ram-comment-fix.patch added to -mm tree
To: akpm@linux-foundation.org,gioh.kim@lge.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,minchan@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:29:20 -0700


The patch titled
     Subject: mm-vmallocc-enhance-vm_map_ram-comment-fix
has been added to the -mm tree.  Its filename is
     mm-vmallocc-enhance-vm_map_ram-comment-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-enhance-vm_map_ram-comment-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
revert-kallsyms-fix-absolute-addresses-for-kaslr.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

