From: akpm@linux-foundation.org
Subject: [merged]
 tools-testing-selftests-makefile-alphasort-the-targets-list.patch removed
 from -mm tree
Date: Fri, 19 Dec 2014 12:37:02 -0800
Message-ID: <54948c6e.Ozl4brQfZQyPxhiy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaLSUhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 15:37:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/Makefile: alphasort the TARGETS list
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-makefile-alphasort-the-targets-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/testing/selftests/Makefile: alphasort the TARGETS list

This list is supposed to be sorted, to reduce patch collisions.

Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN tools/testing/selftests/Makefile~tools-testing-selftests-makefile-alphasort-the-targets-list tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~tools-testing-selftests-makefile-alphasort-the-targets-list
+++ a/tools/testing/selftests/Makefile
@@ -1,22 +1,23 @@
 TARGETS = breakpoints
 TARGETS += cpu-hotplug
 TARGETS += efivarfs
+TARGETS += exec
+TARGETS += firmware
+TARGETS += ftrace
 TARGETS += kcmp
 TARGETS += memfd
 TARGETS += memory-hotplug
-TARGETS += mqueue
 TARGETS += mount
+TARGETS += mqueue
 TARGETS += net
+TARGETS += powerpc
 TARGETS += ptrace
+TARGETS += size
+TARGETS += sysctl
 TARGETS += timers
-TARGETS += vm
-TARGETS += powerpc
 TARGETS += user
-TARGETS += sysctl
-TARGETS += firmware
-TARGETS += ftrace
-TARGETS += exec
-TARGETS += size
+TARGETS += vm
+#Please keep the TARGETS list alphabetically sorted
 
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

