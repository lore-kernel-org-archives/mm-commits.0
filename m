From: akpm@linux-foundation.org
Subject: + uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:58:24 -0700
Message-ID: <200708152058.l7FKwOph014661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbXHOU6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     uvesafb: fix a typo in a warning
has been added to the -mm tree.  Its filename is
     uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uvesafb: fix a typo in a warning
From: Michal Januszewski <spock@gentoo.org>

Replace "vesafb" with "uvesafb" in a kernel warning message.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning
+++ a/drivers/video/uvesafb.c
@@ -412,7 +412,7 @@ static void uvesafb_vbe_state_restore(st
 
 	err = uvesafb_exec(task);
 	if (err || (task->t.regs.eax & 0xffff) != 0x004f)
-		printk(KERN_WARNING "vesafb: VBE state restore call "
+		printk(KERN_WARNING "uvesafb: VBE state restore call "
 				"failed (eax=0x%x, err=%d)\n",
 				task->t.regs.eax, err);
 
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
