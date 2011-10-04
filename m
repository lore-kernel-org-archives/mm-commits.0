From: akpm@google.com
Subject: + drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch added to -mm tree
Date: Tue, 04 Oct 2011 16:43:25 -0700
Message-ID: <201110042343.p94NhP3g008699@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:35013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802Ab1JDXnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 19:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, jeffrey.t.kirsher@intel.com, tomoya-linux@dsn.okisemi.com, toshiharu-linux@dsn.okisemi.com


The patch titled
     Subject: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h: remove unused macro pr_fmt()
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h: remove unused macro pr_fmt()

In file included from drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:22:
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h:24:1: warning: "pr_fmt" redefined
In file included from include/linux/kernel.h:20,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c:21:
include/linux/printk.h:152:1: warning: this is the location of the previous definition

Cc: Tomoya <tomoya-linux@dsn.okisemi.com>
Cc: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h~drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h~drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt
+++ a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
@@ -21,8 +21,6 @@
 #ifndef _PCH_GBE_H_
 #define _PCH_GBE_H_
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/mii.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
_
Subject: Subject: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h: remove unused macro pr_fmt()

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
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
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

