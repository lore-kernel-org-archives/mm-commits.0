From: akpm@linux-foundation.org
Subject: + em28xx-empia-em28xx-audio-too-long.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:04:51 -0700
Message-ID: <201003222304.o2MN4pPJ032722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab0CVXGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, dougsland@redhat.com, mchehab@infradead.org, rob.krakora@messagenetsystems.com


The patch titled
     em28xx: "Empia Em28xx Audio" too long
has been added to the -mm tree.  Its filename is
     em28xx-empia-em28xx-audio-too-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: em28xx: "Empia Em28xx Audio" too long
From: Dan Carpenter <error27@gmail.com>

card->driver is 15 characters and a NULL.  The original code
goes past the end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>
Cc: Robert Krakora <rob.krakora@messagenetsystems.com>
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
+	strcpy(card->driver, "Em28xx Audio");
 	strcpy(card->shortname, "Em28xx Audio");
 	strcpy(card->longname, "Empia Em28xx Audio");
 
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
acpi_pad-processor_aggregator-name-too-long.patch
em28xx-empia-em28xx-audio-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
i915-fix-small-leak-on-error-path.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch

