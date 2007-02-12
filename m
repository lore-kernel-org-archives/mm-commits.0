From: akpm@linux-foundation.org
Subject: + git-acpi-fixup.patch added to -mm tree
Date: Mon, 12 Feb 2007 14:39:10 -0800
Message-ID: <200702122239.l1CMdAM2013359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44688 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030222AbXBLWjM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:39:12 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1CMdAhB027728
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2007 14:39:10 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-acpi-fixup
has been added to the -mm tree.  Its filename is
     git-acpi-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/appledisplay.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/usb/misc/appledisplay.c~git-acpi-fixup drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c~git-acpi-fixup
+++ a/drivers/usb/misc/appledisplay.c
@@ -281,13 +281,8 @@ static int appledisplay_probe(struct usb
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
-<<<<<<< HEAD/drivers/usb/misc/appledisplay.c
-	pdata->bd = backlight_device_register(bl_name, NULL,
-		pdata, &appledisplay_bl_data);
-=======
 	pdata->bd = backlight_device_register(bl_name, NULL, pdata
 						&appledisplay_bl_data);
->>>>>>> /drivers/usb/misc/appledisplay.c
 	if (IS_ERR(pdata->bd)) {
 		err("appledisplay: Backlight registration failed");
 		goto error;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
git-agpgart.patch
git-arm.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-watchdog.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
revert-x86_64-mm-putreg-check.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
