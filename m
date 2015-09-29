From: akpm@linux-foundation.org
Subject: + fs-jffs2-wbufc-remove-stray-semicolon.patch added to -mm tree
Date: Tue, 29 Sep 2015 15:08:57 -0700
Message-ID: <560b0bf9.XW1r+cb8eELxkBG3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbbI2WI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 18:08:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, fengguang.wu@intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jffs2/wbuf.c: remove stray semicolon
has been added to the -mm tree.  Its filename is
     fs-jffs2-wbufc-remove-stray-semicolon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jffs2-wbufc-remove-stray-semicolon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jffs2-wbufc-remove-stray-semicolon.patch

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
Subject: fs/jffs2/wbuf.c: remove stray semicolon

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/wbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/wbuf.c~fs-jffs2-wbufc-remove-stray-semicolon fs/jffs2/wbuf.c
--- a/fs/jffs2/wbuf.c~fs-jffs2-wbufc-remove-stray-semicolon
+++ a/fs/jffs2/wbuf.c
@@ -1264,7 +1264,7 @@ int jffs2_dataflash_setup(struct jffs2_s
 	if ((c->flash_size % c->sector_size) != 0) {
 		c->flash_size = (c->flash_size / c->sector_size) * c->sector_size;
 		pr_warn("flash size adjusted to %dKiB\n", c->flash_size);
-	};
+	}
 
 	c->wbuf_ofs = 0xFFFFFFFF;
 	c->wbuf = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
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
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
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
fs-jffs2-wbufc-remove-stray-semicolon.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

