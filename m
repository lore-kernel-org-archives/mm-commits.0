From: akpm@linux-foundation.org
Subject: + arch-x86-video-fbdevc-add-module_license.patch added to -mm tree
Date: Tue, 15 Apr 2008 22:07:02 -0700
Message-ID: <200804160507.m3G572Km000844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYDPFIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 01:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/video/fbdev.c: add MODULE_LICENSE
has been added to the -mm tree.  Its filename is
     arch-x86-video-fbdevc-add-module_license.patch

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
Subject: arch/x86/video/fbdev.c: add MODULE_LICENSE
From: Adrian Bunk <bunk@kernel.org>

Add the missing MODULE_LICENSE("GPL").

[akpm@linux-foundation.org: nuke wrong patchname-in-comment too]
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/video/fbdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86/video/fbdev.c~arch-x86-video-fbdevc-add-module_license arch/x86/video/fbdev.c
--- a/arch/x86/video/fbdev.c~arch-x86-video-fbdevc-add-module_license
+++ a/arch/x86/video/fbdev.c
@@ -1,5 +1,5 @@
 /*
- * arch/i386/video/fbdev.c - i386 Framebuffer
+ * i386 Framebuffer
  *
  * Copyright (C) 2007 Antonino Daplas <adaplas@gmail.com>
  *
@@ -30,3 +30,5 @@ int fb_is_primary_device(struct fb_info 
 	return retval;
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-x86.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
git-hid.patch
git-ieee1394.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-misc.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-swap_pte_to_pagemap_entry-static.patch
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
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
reiser4.patch
arch-x86-video-fbdevc-add-module_license.patch

