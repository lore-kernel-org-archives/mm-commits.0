From: akpm@linux-foundation.org
Subject: - mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch removed from -mm tree
Date: Mon, 19 Mar 2007 17:48:32 -0800
Message-ID: <200703200148.l2K1mWDw022971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39437 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965712AbXCTBsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 21:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-debug-check-for-the-fault-vs-invalidate-race-tidy
has been removed from the -mm tree.  Its filename was
     mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch

This patch was dropped because it was folded into mm-debug-check-for-the-fault-vs-invalidate-race.patch

------------------------------------------------------
Subject: mm-debug-check-for-the-fault-vs-invalidate-race-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/filemap.c~mm-debug-check-for-the-fault-vs-invalidate-race-tidy mm/filemap.c
--- a/mm/filemap.c~mm-debug-check-for-the-fault-vs-invalidate-race-tidy
+++ a/mm/filemap.c
@@ -120,7 +120,6 @@ void __remove_from_page_cache(struct pag
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
-
 	BUG_ON(page_mapped(page));
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
