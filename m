From: akpm@linux-foundation.org
Subject: - frv-fix-arch-frv-mm-unalignedo-build-error.patch removed from -mm tree
Date: Wed, 30 Apr 2008 05:09:47 -0700
Message-ID: <200804301209.m3UC9lST012630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763570AbYD3MLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dhowells@redhat.com, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     frv: fix arch/frv/mm/unaligned.o build error
has been removed from the -mm tree.  Its filename was
     frv-fix-arch-frv-mm-unalignedo-build-error.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: fix arch/frv/mm/unaligned.o build error
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error caused by
commit 6510d41954dc6a9c8b1dbca7eaca0f23195ca727
(kernel: Move arches to use common unaligned access):

make[2]: *** No rule to make target `arch/frv/mm/unaligned.o', needed by `arch/frv/mm/built-in.o'.  Stop.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/frv/mm/Makefile~frv-fix-arch-frv-mm-unalignedo-build-error arch/frv/mm/Makefile
--- a/arch/frv/mm/Makefile~frv-fix-arch-frv-mm-unalignedo-build-error
+++ a/arch/frv/mm/Makefile
@@ -6,4 +6,4 @@ obj-y := init.o kmap.o
 
 obj-$(CONFIG_MMU) += \
 	pgalloc.o highmem.o fault.o extable.o cache-page.o tlb-flush.o tlb-miss.o \
-	mmu-context.o dma-alloc.o unaligned.o elf-fdpic.o
+	mmu-context.o dma-alloc.o elf-fdpic.o
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-marker_debug-static.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch

