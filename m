From: akpm@linux-foundation.org
Subject: [merged] include-linux-mfd-si476x-coreh-dont-use-0bnnn.patch removed from -mm tree
Date: Mon, 29 Apr 2013 11:45:14 -0700
Message-ID: <20130429184514.861A031C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:41087 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3D2SpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 14:45:17 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so395544veb.5
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 11:45:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.smirnov@gmail.com, hans.verkuil@cisco.com, sam@ravnborg.org, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mfd/si476x-core.h: don't use 0bNNN
has been removed from the -mm tree.  Its filename was
     include-linux-mfd-si476x-coreh-dont-use-0bnnn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mfd/si476x-core.h: don't use 0bNNN

This doesn't compile with sparc64 gcc-3.4.5.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mfd/si476x-core.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mfd/si476x-core.h~include-linux-mfd-si476x-coreh-dont-use-0bnnn include/linux/mfd/si476x-core.h
--- a/include/linux/mfd/si476x-core.h~include-linux-mfd-si476x-coreh-dont-use-0bnnn
+++ a/include/linux/mfd/si476x-core.h
@@ -515,11 +515,11 @@ enum si476x_fm_receiver_properties {
 };
 
 enum si476x_prop_audio_pwr_line_filter_bits {
-	SI476X_PROP_PWR_HARMONICS_MASK	= 0b0000000000011111,
-	SI476X_PROP_PWR_GRID_MASK	= 0b0000000100000000,
-	SI476X_PROP_PWR_ENABLE_MASK	= 0b0000001000000000,
-	SI476X_PROP_PWR_GRID_50HZ	= 0b0000000000000000,
-	SI476X_PROP_PWR_GRID_60HZ	= 0b0000000100000000,
+	SI476X_PROP_PWR_HARMONICS_MASK	= 0x001f,
+	SI476X_PROP_PWR_GRID_MASK	= 0x0100,
+	SI476X_PROP_PWR_ENABLE_MASK	= 0x0200,
+	SI476X_PROP_PWR_GRID_50HZ	= 0x0000,
+	SI476X_PROP_PWR_GRID_60HZ	= 0x0100,
 };
 
 enum si476x_prop_fm_rds_config_bits {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-usb-storage-realtek_crc-fix-build.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
init-mainc-convert-to-pr_foo-fix.patch
init-mainc-convert-to-pr_foo-fix-fix.patch
rtc-ds1307-long-block-operations-bugfix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

