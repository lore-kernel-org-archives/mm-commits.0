From: akpm@linux-foundation.org
Subject: - git-dvb-fixup.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:05:15 -0800
Message-ID: <200702150805.l1F85Fcr024022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXBOIFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:05:17 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1F85GhB002749
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2007 00:05:16 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-dvb-fixup
has been removed from the -mm tree.  Its filename was
     git-dvb-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-dvb-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-maxiradio.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/media/radio/radio-maxiradio.c~git-dvb-fixup drivers/media/radio/radio-maxiradio.c
--- a/drivers/media/radio/radio-maxiradio.c~git-dvb-fixup
+++ a/drivers/media/radio/radio-maxiradio.c
@@ -99,14 +99,7 @@ module_param(radio_nr, int, 0);
 #define BITS2FREQ(x)	((x) * FREQ_STEP - FREQ_IF)
 
 
-<<<<<<< HEAD/drivers/media/radio/radio-maxiradio.c
-static int radio_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg);
-
 static const struct file_operations maxiradio_fops = {
-=======
-static struct file_operations maxiradio_fops = {
->>>>>>> /drivers/media/radio/radio-maxiradio.c
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch
git-gccbug-fixup.patch
