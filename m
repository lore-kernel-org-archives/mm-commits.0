From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:10:48 -0700
Message-ID: <55f31928.N8lPHWJ0b4b1lrlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIKSKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile                      |    1 +
 tools/testing/selftests/Makefile |    1 +
 2 files changed, 2 insertions(+)

diff -puN mm/Makefile~linux-next-rejects mm/Makefile
--- a/mm/Makefile~linux-next-rejects
+++ a/mm/Makefile
@@ -80,3 +80,4 @@ obj-$(CONFIG_PAGE_EXTENSION) += page_ext
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
+obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
diff -puN tools/testing/selftests/Makefile~linux-next-rejects tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~linux-next-rejects
+++ a/tools/testing/selftests/Makefile
@@ -6,6 +6,7 @@ TARGETS += firmware
 TARGETS += ftrace
 TARGETS += futex
 TARGETS += kcmp
+TARGETS += kdbus
 TARGETS += membarrier
 TARGETS += memfd
 TARGETS += memory-hotplug
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch
scripts-extract-certc-fix-err-call-in-write_cert.patch
mm.patch
mm-srcu-ify-shrinkers-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

