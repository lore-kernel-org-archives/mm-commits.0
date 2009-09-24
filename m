From: akpm@linux-foundation.org
Subject: [merged] drivers-md-dm-log-userspace-basec-fix-warning.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:49 -0700
Message-ID: <200909241937.n8OJbn0v005325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbZIXTiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agk@redhat.com, jbrassow@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/md/dm-log-userspace-base.c: fix warning
has been removed from the -mm tree.  Its filename was
     drivers-md-dm-log-userspace-basec-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/md/dm-log-userspace-base.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

mips:

drivers/md/dm-log-userspace-base.c: In function `userspace_ctr':
drivers/md/dm-log-userspace-base.c:159: warning: cast from pointer to integer of different size

Cc: Neil Brown <neilb@suse.de>
Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log-userspace-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-log-userspace-base.c~drivers-md-dm-log-userspace-basec-fix-warning drivers/md/dm-log-userspace-base.c
--- a/drivers/md/dm-log-userspace-base.c~drivers-md-dm-log-userspace-basec-fix-warning
+++ a/drivers/md/dm-log-userspace-base.c
@@ -156,7 +156,7 @@ static int userspace_ctr(struct dm_dirty
 	}
 
 	/* The ptr value is sufficient for local unique id */
-	lc->luid = (uint64_t)lc;
+	lc->luid = (unsigned long)lc;
 
 	lc->ti = ti;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

