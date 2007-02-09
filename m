From: akpm@linux-foundation.org
Subject: + git-backlight-acpi-fix.patch added to -mm tree
Date: Thu, 08 Feb 2007 16:27:20 -0800
Message-ID: <200702090028.l190SRtD032030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965596AbXBIA2c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 19:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rpurdie@rpsys.net


The patch titled
     git-backlight acpi fix
has been added to the -mm tree.  Its filename is
     git-backlight-acpi-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-backlight acpi fix
From: Andrew Morton <akpm@linux-foundation.org>

Hope this is right..

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/acpi/video.c~git-backlight-acpi-fix drivers/acpi/video.c
--- a/drivers/acpi/video.c~git-backlight-acpi-fix
+++ a/drivers/acpi/video.c
@@ -622,7 +622,6 @@ static void acpi_video_device_find_cap(s
 			kfree(name);
 			return;
 		}
-		acpi_video_data->owner = THIS_MODULE;
 		acpi_video_data->get_brightness =
 			acpi_video_get_brightness;
 		acpi_video_data->update_status =
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
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
git-backlight-acpi-fix.patch
