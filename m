From: akpm@linux-foundation.org
Subject: + frv-fix-arch-frv-mm-unalignedo-build-error.patch added to -mm tree
Date: Tue, 29 Apr 2008 17:30:01 -0700
Message-ID: <200804300030.m3U0U1na018029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547AbYD3Aaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 20:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, harvey.harrison@gmail.com


The patch titled
     frv: fix arch/frv/mm/unaligned.o build error
has been added to the -mm tree.  Its filename is
     frv-fix-arch-frv-mm-unalignedo-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
git-nfsd.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
usb-storage-onetouchc-make-a-function-static.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch

