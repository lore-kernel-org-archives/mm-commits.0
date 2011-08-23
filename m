From: akpm@linux-foundation.org
Subject: + mm-add-comments-to-explain-mm_struct-fields-fix.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:58:12 -0700
Message-ID: <201108232237.p7NMb7tu011389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab1HWWhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 18:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com


The patch titled
     mm-add-comments-to-explain-mm_struct-fields-fix
has been added to the -mm tree.  Its filename is
     mm-add-comments-to-explain-mm_struct-fields-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-comments-to-explain-mm_struct-fields-fix
From: Andrew Morton <akpm@linux-foundation.org>

add missing ;

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields-fix
+++ a/include/linux/mm_types.h
@@ -282,7 +282,7 @@ struct mm_struct {
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
 
 	unsigned long total_vm;		/* Total pages mapped */
-	unsigned long locked_vm		/* Pages that have PG_mlocked set */
+	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
 	unsigned long pinned_vm;	/* Refcount permanently increased */
 	unsigned long shared_vm;	/* Shared pages (files) */
 	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

headers_check-is-broken.patch
samples-hidraw-is-busted.patch
alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
drivers-base-inodec-let-vmstat_text-be-optional-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

