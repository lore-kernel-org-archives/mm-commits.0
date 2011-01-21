From: akpm@linux-foundation.org
Subject: + backlight-add-backlight-type-fix-fix.patch added to -mm tree
Date: Thu, 20 Jan 2011 17:06:52 -0800
Message-ID: <201101210106.p0L16qM8013139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411Ab1AUBHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 20:07:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, michael.hennerich@analog.com, mjg@redhat.com, vapier@gentoo.org


The patch titled
     backlight-add-backlight-type-fix-fix
has been added to the -mm tree.  Its filename is
     backlight-add-backlight-type-fix-fix.patch

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
Subject: backlight-add-backlight-type-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-add-backlight-type-fix-fix drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-add-backlight-type-fix-fix
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -795,7 +795,7 @@ static int __devinit adp8870_probe(struc
 	mutex_init(&data->lock);
 
 	memset(&props, 0, sizeof(props));
-	props.type = BACKLIGHT_PLATFORM;
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = props.brightness = ADP8870_MAX_BRIGHTNESS;
 	bl = backlight_device_register(dev_driver_string(&client->dev),
 			&client->dev, data, &adp8870_bl_ops, &props);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

