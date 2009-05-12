From: akpm@linux-foundation.org
Subject: [folded] input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 12 May 2009 13:41:46 -0700
Message-ID: <200905122101.n4CL122i005952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbZELVDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@mail.ru, mamurph@cs.clemson.edu, mm-commits@vger.kernel.org


The patch titled
     input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch

This patch was dropped because it was folded into input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#229: FILE: Documentation/input/xpad.txt:202:
+   $

ERROR: trailing whitespace
#233: FILE: Documentation/input/xpad.txt:206:
+  $

ERROR: trailing whitespace
#239: FILE: Documentation/input/xpad.txt:212:
+  $

ERROR: trailing whitespace
#242: FILE: Documentation/input/xpad.txt:215:
+  $

ERROR: trailing whitespace
#246: FILE: Documentation/input/xpad.txt:219:
+  $

ERROR: trailing whitespace
#252: FILE: Documentation/input/xpad.txt:225:
+  $

ERROR: trailing whitespace
#259: FILE: Documentation/input/xpad.txt:232:
+  $

ERROR: trailing whitespace
#264: FILE: Documentation/input/xpad.txt:237:
+  $

ERROR: trailing whitespace
#271: FILE: Documentation/input/xpad.txt:244:
+  $

ERROR: trailing whitespace
#278: FILE: Documentation/input/xpad.txt:251:
+  $

ERROR: trailing whitespace
#283: FILE: Documentation/input/xpad.txt:256:
+  $

total: 11 errors, 0 warnings, 309 lines checked

./patches/input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/xpad.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/input/xpad.txt~input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes Documentation/input/xpad.txt
--- a/Documentation/input/xpad.txt~input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes
+++ a/Documentation/input/xpad.txt
@@ -266,7 +266,7 @@ documented below. First, however, we pre
 
 I have to thank ITO Takayuki for the detailed info on his site
  http://euc.jp/periphs/xbox-controller.ja.html.
- 
+
 His useful info and both the usb-skeleton as well as the iforce input driver
 (Greg Kroah-Hartmann; Vojtech Pavlik) helped a lot in rapid prototyping
 the basic functionality.
@@ -304,7 +304,7 @@ I:  If#= 0 Alt= 0 #EPs= 2 Cls=58(unk. ) 
 E:  Ad=82(I) Atr=03(Int.) MxPS=  32 Ivl=4ms
 E:  Ad=02(O) Atr=03(Int.) MxPS=  32 Ivl=4ms
 
--- 
+--
 Marko Friedemann <mfr@bmx-chemnitz.de>
 2002-07-16
  - original doc
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alpha-unbreak-percpu-again.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-keyboard-introduce-lm8323-driver.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

