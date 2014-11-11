From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 11 Nov 2014 13:18:24 -0800
Message-ID: <54627d20.nsHjxmcz0RbQAU9g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaKKVSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 16:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/base.c  |    3 ---
 include/linux/of.h |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/of/base.c~linux-next-git-rejects drivers/of/base.c
--- a/drivers/of/base.c~linux-next-git-rejects
+++ a/drivers/of/base.c
@@ -1292,8 +1292,6 @@ int of_property_read_u64_array(const str
 }
 
 /**
-<<<<<<< HEAD
-=======
  * of_property_read_string - Find and read a string from a property
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
@@ -1324,7 +1322,6 @@ int of_property_read_string(struct devic
 EXPORT_SYMBOL_GPL(of_property_read_string);
 
 /**
->>>>>>> linux-next/akpm-base
  * of_property_match_string() - Find string in a list and return index
  * @np: pointer to node containing string list property
  * @propname: string list property name
diff -puN include/linux/of.h~linux-next-git-rejects include/linux/of.h
--- a/include/linux/of.h~linux-next-git-rejects
+++ a/include/linux/of.h
@@ -512,8 +512,6 @@ static inline int of_property_read_u64_a
 	return -ENOSYS;
 }
 
-<<<<<<< HEAD
-=======
 static inline int of_property_read_string(struct device_node *np,
 					  const char *propname,
 					  const char **out_string)
@@ -521,7 +519,6 @@ static inline int of_property_read_strin
 	return -ENOSYS;
 }
 
->>>>>>> linux-next/akpm-base
 static inline int of_property_read_string_helper(struct device_node *np,
 						 const char *propname,
 						 const char **out_strs, size_t sz, int index)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-ignore-marks-not-respected-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

