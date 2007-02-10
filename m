From: akpm@linux-foundation.org
Subject: - git-backlight-asus-fix.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:26:54 -0800
Message-ID: <200702100526.l1A5QsgN004653@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36810 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXBJF1D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     git-backlight-asus-fix
has been removed from the -mm tree.  Its filename was
     git-backlight-asus-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-backlight-asus-fix
From: Andrew Morton <akpm@linux-foundation.org>

Better testing, please.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/asus-laptop.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/asus-laptop.c~git-backlight-asus-fix drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c~git-backlight-asus-fix
+++ a/drivers/misc/asus-laptop.c
@@ -196,7 +196,6 @@ static struct backlight_device *asus_bac
 static int read_brightness(struct backlight_device *bd);
 static int update_bl_status(struct backlight_device *bd);
 static struct backlight_properties asusbl_data = {
-	.owner = THIS_MODULE,
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 	.max_brightness = 15,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-input.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
