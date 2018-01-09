From: akpm@linux-foundation.org
Subject: [folded-merged]
 selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
 removed from -mm tree
Date: Mon, 08 Jan 2018 16:25:50 -0800
Message-ID: <5a540c0e.p2mY4lk39QFdhlCE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbeAIAZv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 19:25:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, shuah@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix
has been removed from the -mm tree.  Its filename was
     selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch

This patch was dropped because it was folded into selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix

restore tools/testing/selftests/vm/Makefile alpha ordering

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -8,18 +8,18 @@ endif
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 LDLIBS = -lrt
 TEST_GEN_FILES = compaction_test
+TEST_GEN_FILES += gup_benchmark
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-shm
 TEST_GEN_FILES += map_hugetlb
+TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += mlock2-tests
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
-TEST_GEN_FILES += mlock-random-test
-TEST_GEN_FILES += virtual_address_range
-TEST_GEN_FILES += gup_benchmark
 TEST_GEN_FILES += va_128TBswitch
+TEST_GEN_FILES += virtual_address_range
 
 TEST_PROGS := run_vmtests
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

