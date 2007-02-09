From: akpm@linux-foundation.org
Subject: + git-backlight-sony-fix.patch added to -mm tree
Date: Thu, 08 Feb 2007 16:54:27 -0800
Message-ID: <200702090055.l190tYNf032737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47647 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945957AbXBIAzm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 19:55:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rpurdie@rpsys.net


The patch titled
     git-backlight-sony-fix
has been added to the -mm tree.  Its filename is
     git-backlight-sony-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-backlight-sony-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/misc/sony-laptop.c~git-backlight-sony-fix drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~git-backlight-sony-fix
+++ a/drivers/misc/sony-laptop.c
@@ -242,7 +242,6 @@ static ssize_t sony_acpi_store(struct de
 static struct platform_driver sncpf_driver = {
 	.driver = {
 		   .name = "sony-laptop",
-		   .owner = THIS_MODULE,
 		   }
 };
 static struct platform_device *sncpf_device;
@@ -356,7 +355,6 @@ static int sony_backlight_get_brightness
 
 static struct backlight_device *sony_backlight_device;
 static struct backlight_properties sony_backlight_properties = {
-	.owner = THIS_MODULE,
 	.update_status = sony_backlight_update_status,
 	.get_brightness = sony_backlight_get_brightness,
 	.max_brightness = SONY_MAX_BRIGHTNESS - 1,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
git-backlight-sony-fix.patch
