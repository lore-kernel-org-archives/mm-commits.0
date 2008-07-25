From: akpm@linux-foundation.org
Subject: - cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:21:37 -0700
Message-ID: <200807250021.m6P0LcAP013847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYGYAVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     res_counter: fix building failure
has been removed from the -mm tree.  Its filename was
     cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix.patch

This patch was dropped because it was folded into cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: res_counter: fix building failure
From: Li Zefan <lizf@cn.fujitsu.com>

kernel/res_counter.c: In function 'res_counter_memparse_write_strategy':
kernel/res_counter.c:115: error: implicit declaration of function 'PAGE_ALIGN'

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/res_counter.c~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix kernel/res_counter.c
--- a/kernel/res_counter.c~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix
+++ a/kernel/res_counter.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/res_counter.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 
 void res_counter_init(struct res_counter *counter)
 {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
call_usermodehelper-increase-reliability.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
ext3-kill-2-useless-magic-numbers.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix.patch
devcgroup-code-cleanup.patch
devcgroup-code-cleanup-fix.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
cpuset-avoid-unnecessary-sched-domains-rebuilding.patch

