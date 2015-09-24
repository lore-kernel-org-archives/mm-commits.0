From: akpm@linux-foundation.org
Subject: + zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch added to -mm tree
Date: Thu, 24 Sep 2015 14:59:05 -0700
Message-ID: <56047229.C23QE3AzABREc0Ck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbbIXV7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Sep 2015 17:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-add-comments-for-inuse-to-zspage-v2-fix
has been added to the -mm tree.  Its filename is
     zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch

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
Subject: zsmalloc-add-comments-for-inuse-to-zspage-v2-fix

fix grammar

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage-v2-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage-v2-fix
+++ a/mm/zsmalloc.c
@@ -38,7 +38,7 @@
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
  *	page->mapping: class index and fullness group of the zspage
- *	page->inuse: the objects number that is used in this zspage
+ *	page->inuse: the number of objects that are used in this zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
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

