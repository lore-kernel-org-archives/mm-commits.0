From: akpm@linux-foundation.org
Subject: + memcg-make-mem_cgroup_read_stat-unsigned-fix.patch added to -mm tree
Date: Tue, 22 Sep 2015 15:23:21 -0700
Message-ID: <5601d4d9.65C2rfp/SOEPI9I9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478AbbIVWXW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 18:23:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-make-mem_cgroup_read_stat-unsigned-fix
has been added to the -mm tree.  Its filename is
     memcg-make-mem_cgroup_read_stat-unsigned-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-make-mem_cgroup_read_stat-unsigned-fix.patch

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
Subject: memcg-make-mem_cgroup_read_stat-unsigned-fix

fix old typo while we're in there

Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_read_stat-unsigned-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_read_stat-unsigned-fix
+++ a/mm/memcontrol.c
@@ -661,7 +661,7 @@ mem_cgroup_largest_soft_limit_node(struc
  *
  * If there are kernel internal actions which can make use of some not-exact
  * value, and reading all cpu value can be performance bottleneck in some
- * common workload, threashold and synchronization as vmstat[] should be
+ * common workload, threshold and synchronization as vmstat[] should be
  * implemented.
  */
 static unsigned long
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

