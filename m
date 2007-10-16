From: akpm@linux-foundation.org
Subject: - ps3-system-bus-add_uevent_var-fallout.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:18:00 -0700
Message-ID: <200710160218.l9G2I0Kn004250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757331AbXJPCSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PS3 system bus add_uevent_var() fallout
has been removed from the -mm tree.  Its filename was
     ps3-system-bus-add_uevent_var-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PS3 system bus add_uevent_var() fallout
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

PS3 system bus add_uevent_var() fallout: kill unused variables

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/system-bus.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/platforms/ps3/system-bus.c~ps3-system-bus-add_uevent_var-fallout arch/powerpc/platforms/ps3/system-bus.c
--- a/arch/powerpc/platforms/ps3/system-bus.c~ps3-system-bus-add_uevent_var-fallout
+++ a/arch/powerpc/platforms/ps3/system-bus.c
@@ -440,7 +440,6 @@ static void ps3_system_bus_shutdown(stru
 static int ps3_system_bus_uevent(struct device *_dev, struct kobj_uevent_env *env)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
-	int i = 0, length = 0;
 
 	if (add_uevent_var(env, "MODALIAS=ps3:%d", dev->match_id))
 		return -ENOMEM;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch
ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch
ps3fb-clean-up-includes.patch
ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch
ps3fb-fix-possible-overlap-of-gpu-command-buffer-and-frame-buffer.patch
ps3fb-use-fb_infopar-properly.patch
ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch
ps3fb-add-virtual-screen-and-panning-support.patch
ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch
fb-move-and-rename-extern-declaration-for-global_mode_option.patch
ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch
