From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 23 Jul 2014 12:00:00 -0700
Message-ID: <53d00630.Ts7xCr61Y4m/RLaK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:35035 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWTAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 15:00:03 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so454199pab.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 12:00:02 -0700 (PDT)
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

 drivers/media/dvb-frontends/si2168.c      |    3 ---
 drivers/media/dvb-frontends/si2168_priv.h |    4 ----
 drivers/media/tuners/si2157.c             |    8 --------
 3 files changed, 15 deletions(-)

diff -puN drivers/media/dvb-frontends/si2168.c~linux-next-git-rejects drivers/media/dvb-frontends/si2168.c
--- a/drivers/media/dvb-frontends/si2168.c~linux-next-git-rejects
+++ a/drivers/media/dvb-frontends/si2168.c
@@ -362,8 +362,6 @@ static int si2168_init(struct dvb_fronte
 	if (ret)
 		goto err;
 
-<<<<<<< HEAD
-=======
 	cmd.args[0] = 0x05;
 	cmd.args[1] = 0x00;
 	cmd.args[2] = 0xaa;
@@ -400,7 +398,6 @@ static int si2168_init(struct dvb_fronte
 		goto err;
 	}
 
->>>>>>> linux-next/akpm-base
 	/* cold state - try to download firmware */
 	dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
 			KBUILD_MODNAME, si2168_ops.info.name);
diff -puN drivers/media/dvb-frontends/si2168_priv.h~linux-next-git-rejects drivers/media/dvb-frontends/si2168_priv.h
--- a/drivers/media/dvb-frontends/si2168_priv.h~linux-next-git-rejects
+++ a/drivers/media/dvb-frontends/si2168_priv.h
@@ -22,13 +22,9 @@
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
 
-<<<<<<< HEAD
-#define SI2168_FIRMWARE "dvb-demod-si2168-02.fw"
-=======
 #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
 #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
 #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
->>>>>>> linux-next/akpm-base
 
 /* state struct */
 struct si2168 {
diff -puN drivers/media/tuners/si2157.c~linux-next-git-rejects drivers/media/tuners/si2157.c
--- a/drivers/media/tuners/si2157.c~linux-next-git-rejects
+++ a/drivers/media/tuners/si2157.c
@@ -60,18 +60,10 @@ static int si2157_cmd_execute(struct si2
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
-<<<<<<< HEAD
-	if (!((buf[0] >> 7) & 0x01)) {
-		ret = -ETIMEDOUT;
-		goto err_mutex_unlock;
-	} else {
-		ret = 0;
-=======
 		if (!((cmd->args[0] >> 7) & 0x01)) {
 			ret = -ETIMEDOUT;
 			goto err_mutex_unlock;
 		}
->>>>>>> linux-next/akpm-base
 	}
 
 	ret = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

