From: akpm@linux-foundation.org
Subject: + move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch added to -mm tree
Date: Thu, 09 Feb 2012 15:04:07 -0800
Message-ID: <20120209230407.D1930A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:56131 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab2BIXEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 18:04:10 -0500
Received: by wgbds12 with SMTP id ds12so69664wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 15:04:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, dyoung@redhat.com, fengguang.wu@intel.com, fweisbec@gmail.com, penberg@cs.helsinki.fi


The patch titled
     Subject: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix
has been added to the -mm tree.  Its filename is
     move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix

build the targets before trying to execute them

Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm-fix tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~move-hugepage-test-examples-to-tools-testing-selftests-vm-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -7,7 +7,7 @@ all: hugepage-mmap hugepage-shm  map_hug
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
-run_tests:
+run_tests: all
 	/bin/sh ./run_vmtests
 
 clean:
_
Subject: Subject: move-hugepage-test-examples-to-tools-testing-selftests-vm-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
fs-btrfs-inode-mapc-fix-warnings.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

