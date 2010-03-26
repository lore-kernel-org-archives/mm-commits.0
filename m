From: akpm@linux-foundation.org
Subject: [merged] em28xx-empia-em28xx-audio-too-long.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:39 -0400
Message-ID: <201003261938.o2QJccpT016703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab0CZTjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, dougsland@redhat.com, mchehab@infradead.org, rob.krakora@messagenetsystems.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     em28xx: "Empia Em28xx Audio" too long
has been removed from the -mm tree.  Its filename was
     em28xx-empia-em28xx-audio-too-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: em28xx: "Empia Em28xx Audio" too long
From: Dan Carpenter <error27@gmail.com>

card->driver is 15 characters and a NULL.  The original code goes past the
end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/em28xx/em28xx-audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/em28xx/em28xx-audio.c~em28xx-empia-em28xx-audio-too-long drivers/media/video/em28xx/em28xx-audio.c
--- a/drivers/media/video/em28xx/em28xx-audio.c~em28xx-empia-em28xx-audio-too-long
+++ a/drivers/media/video/em28xx/em28xx-audio.c
@@ -491,7 +491,7 @@ static int em28xx_audio_init(struct em28
 	strcpy(pcm->name, "Empia 28xx Capture");
 
 	snd_card_set_dev(card, &dev->udev->dev);
-	strcpy(card->driver, "Empia Em28xx Audio");
+	strcpy(card->driver, "Em28xx-Audio");
 	strcpy(card->shortname, "Em28xx Audio");
 	strcpy(card->longname, "Empia Em28xx Audio");
 
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
acpi_pad-processor_aggregator-name-too-long.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

