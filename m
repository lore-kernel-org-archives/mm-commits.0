From: akpm@linux-foundation.org
Subject: [folded] readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups-fix.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:06:04 -0700
Message-ID: <201110282206.p9SM65nj020687@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:32313 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1J1WGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, apw@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups-fix
has been removed from the -mm tree.  Its filename was
     readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups-fix.patch

This patch was dropped because it was folded into readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups-fix

remove unused getname_flags()

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/namei.c~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups-fix fs/namei.c
--- a/fs/namei.c~readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups-fix
+++ a/fs/namei.c
@@ -161,11 +161,6 @@ static char *getname_flags_empty(const c
 	return result;
 }
 
-static char *getname_flags(const char __user * filename, int flags)
-{
-	return getname_flags_empty(filename, flags, 0);
-}
-
 char *getname(const char __user * filename)
 {
 	return getname_flags_empty(filename, 0, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

