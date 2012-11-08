From: akpm@linux-foundation.org
Subject: + selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix.patch added to -mm tree
Date: Thu, 08 Nov 2012 13:30:00 -0800
Message-ID: <20121108213001.E94CB5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:54017 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2KHVaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 16:30:04 -0500
Received: by mail-ea0-f202.google.com with SMTP id q10so208862eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 13:30:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com


The patch titled
     Subject: selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix
has been added to the -mm tree.  Its filename is
     selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix.patch

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
Subject: selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/Makefile~selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,7 +1,7 @@
 # Makefile for vm selftests
 
 CC = $(CROSS_COMPILE)gcc
-CFLAGS = -Wall
+CFLAGS = -Wall -Wextra
 
 all: hugepage-mmap hugepage-shm  map_hugetlb thuge-gen
 %: %.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array-fix.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
selftests-add-a-test-program-for-variable-huge-page-sizes-in-mmap-shmget-fix.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

