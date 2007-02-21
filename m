From: akpm@linux-foundation.org
Subject: + make-struct-vmi_ops-static.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:53:24 -0800
Message-ID: <200702212153.l1LLrOrU027576@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50914 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXBUV4m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 16:56:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ak@suse.de, zach@vmware.com


The patch titled
     make struct vmi_ops static
has been added to the -mm tree.  Its filename is
     make-struct-vmi_ops-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make struct vmi_ops static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/vmi.c~make-struct-vmi_ops-static arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~make-struct-vmi_ops-static
+++ a/arch/i386/kernel/vmi.c
@@ -56,7 +56,7 @@ static int disable_tsc;
 static int disable_mtrr;
 
 /* Cached VMI operations */
-struct {
+static struct {
 	void (*cpuid)(void /* non-c */);
 	void (*_set_ldt)(u32 selector);
 	void (*set_tr)(u32 selector);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-ubi.patch
git-net.patch
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
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
lumpy-reclaim-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
