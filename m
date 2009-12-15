From: akpm@linux-foundation.org
Subject: [folded] blackfin-sd-host-controller-driver-fix-fix-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:11:42 -0800
Message-ID: <200912150111.nBF1BgKU023379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbZLOBMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:12:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cliffcai.sh@gmail.com, cooloney@kernel.org, linux-mmc@vger.kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin-sd-host-controller-driver-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     blackfin-sd-host-controller-driver-fix-fix-fix.patch

This patch was dropped because it was folded into blackfin-sd-host-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin-sd-host-controller-driver-fix-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-mmc@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliffcai.sh@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/bfin_sdh.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix-fix-fix drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix-fix-fix
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -162,6 +162,7 @@ static int sdh_setup_data(struct sdh_hos
 				i, host->sg_cpu[i].start_addr,
 				host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,
 				host->sg_cpu[i].x_modify);
+		}
 	}
 	flush_dcache_range((unsigned int)host->sg_cpu,
 		(unsigned int)host->sg_cpu +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
errh-add-helper-function-to-simplify-pointer-error-checking.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim.patch
blackfin-sd-host-controller-driver.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

