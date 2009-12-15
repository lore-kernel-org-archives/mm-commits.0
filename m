From: akpm@linux-foundation.org
Subject: [folded] blackfin-sd-host-controller-driver-fix-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:11:39 -0800
Message-ID: <200912150111.nBF1BdEk023259__26729.6829414137$1260839578$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758391AbZLOBMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:12:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cliffcai.sh@gmail.com, cooloney@kernel.org, linux-mmc@vger.kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin-sd-host-controller-driver-fix-fix
has been removed from the -mm tree.  Its filename was
     blackfin-sd-host-controller-driver-fix-fix.patch

This patch was dropped because it was folded into blackfin-sd-host-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin-sd-host-controller-driver-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

imadope

Cc: <linux-mmc@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliffcai.sh@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/bfin_sdh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix-fix drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix-fix
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -307,7 +307,7 @@ static int sdh_data_done(struct sdh_host
 	if (host->mrq->stop) {
 		sdh_stop_clock(host);
 		sdh_start_cmd(host, host->mrq->stop);
-	} else }
+	} else {
 		sdh_finish_request(host, host->mrq);
 	}
 
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
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

