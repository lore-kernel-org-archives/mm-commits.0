From: akpm@osdl.org
Subject: - md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:27:57 -0800
Message-ID: <200612100827.kBA8RvWC018862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421AbWLJI2C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, neilb@suse.de, raziebe@gmail.com, mm-commits@vger.kernel.org


The patch titled
     md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix
has been removed from the -mm tree.  Its filename was
     md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch

This patch was dropped because it was folded into md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch

------------------------------------------------------
Subject: md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix
From: Andrew Morton <akpm@osdl.org>

Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix
+++ a/drivers/md/raid5.c
@@ -2691,7 +2691,7 @@ static struct bio *remove_bio_from_retry
  *  first).
  *  If the read failed..
  */
-int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
+static int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
 {
 	struct bio* raid_bi  = bi->bi_private;
 	mddev_t *mddev;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
submit-checklist-update.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
sched-add-option-to-serialize-load-balancing.patch
kernel-schedc-whitespace-cleanups.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-userspace-interface.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

