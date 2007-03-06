From: akpm@linux-foundation.org
Subject: + make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:45:20 -0800
Message-ID: <200703060345.l263jKhg010977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933906AbXCFDqM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, airlied@linux.ie


The patch titled
     make drivers/char/drm/drm_vm.c:drm_io_prot() static
has been added to the -mm tree.  Its filename is
     make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make drivers/char/drm/drm_vm.c:drm_io_prot() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/drm_vm.c~make-drivers-char-drm-drm_vmcdrm_io_prot-static drivers/char/drm/drm_vm.c
--- a/drivers/char/drm/drm_vm.c~make-drivers-char-drm-drm_vmcdrm_io_prot-static
+++ a/drivers/char/drm/drm_vm.c
@@ -41,7 +41,7 @@
 static void drm_vm_open(struct vm_area_struct *vma);
 static void drm_vm_close(struct vm_area_struct *vma);
 
-pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
+static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
 {
 	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
