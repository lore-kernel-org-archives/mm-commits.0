From: akpm@linux-foundation.org
Subject: [folded] fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix.patch removed from -mm tree
Date: Mon, 25 Jun 2012 15:08:41 -0700
Message-ID: <20120625220842.5CA74A0280@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38953 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab2FYWIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jun 2012 18:08:44 -0400
Received: by eeit10 with SMTP id t10so270179eei.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2012 15:08:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix
has been removed from the -mm tree.  Its filename was
     fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix.patch

This patch was dropped because it was folded into fs-introduce-pipe-only-dump-mode-suid_dumpable=3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix

remove unneeeded casts

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix kernel/sysctl.c
--- a/kernel/sysctl.c~fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix
+++ a/kernel/sysctl.c
@@ -1992,10 +1992,10 @@ static int do_proc_dointvec_minmax_conv(
 		int val = *valp;
 		if (val < 0) {
 			*negp = true;
-			*lvalp = (unsigned long)-val;
+			*lvalp = -val;
 		} else {
 			*negp = false;
-			*lvalp = (unsigned long)val;
+			*lvalp = val;
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
x86-mce-use-new-printk-recursion-disabling-interface-fix.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
printk-have-printk-never-buffer-its-data.patch

