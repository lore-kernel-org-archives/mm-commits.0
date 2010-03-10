From: akpm@linux-foundation.org
Subject: [folded] cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:55:53 -0800
Message-ID: <201003102255.o2AMtr1u008776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0CJW4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, lizf@cn.fujitsu.com, menage@google.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix
has been removed from the -mm tree.  Its filename was
     cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch

This patch was dropped because it was folded into cgroup-implement-eventfd-based-generic-api-for-notifications.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Kconfig fix

Cgroup's eventfd feature has depenedecy to EVENTFD

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix init/Kconfig
--- a/init/Kconfig~cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix
+++ a/init/Kconfig
@@ -475,6 +475,7 @@ config HAVE_UNSTABLE_SCHED_CLOCK
 
 menuconfig CGROUPS
 	boolean "Control Group support"
+	depends on EVENTFD
 	help
 	  This option adds support for grouping sets of processes together, for
 	  use with process control subsystems such as Cpusets, CFS, memory
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

nommu-fix-build-breakage.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-unloading.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-improve-performance-in-moving-swap-charge.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch
linux-next.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

