From: akpm@linux-foundation.org
Subject: [folded] cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 28 Jul 2011 13:44:37 -0700
Message-ID: <201107282044.p6SKicSQ007414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748Ab1G1Uol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 16:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch

This patch was dropped because it was folded into cris-fix-a-build-error-in-kernel-forkc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#37: FILE: arch/cris/include/asm/thread_info.h:70:
+#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))

ERROR: space required after that ',' (ctx:VxV)
#37: FILE: arch/cris/include/asm/thread_info.h:70:
+#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
                                                                                              ^

total: 1 errors, 1 warnings, 18 lines checked

./patches/cris-fix-a-build-error-in-kernel-forkc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/thread_info.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes arch/cris/include/asm/thread_info.h
--- a/arch/cris/include/asm/thread_info.h~cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes
+++ a/arch/cris/include/asm/thread_info.h
@@ -67,7 +67,8 @@ struct thread_info {
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 /* thread information allocation */
-#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
+#define alloc_thread_info_node(tsk, node)	\
+	((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

