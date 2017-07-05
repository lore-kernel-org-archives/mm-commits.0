From: akpm@linux-foundation.org
Subject: + alsa-opl4-move-inline-before-return-type.patch added to -mm
 tree
Date: Wed, 05 Jul 2017 13:45:38 -0700
Message-ID: <595d4ff2.MVq7/681FgPAVErQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbdGEUpo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, clemens@ladisch.de, perex@perex.cz, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ALSA: opl4: move inline before return type
has been added to the -mm tree.  Its filename is
     alsa-opl4-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alsa-opl4-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alsa-opl4-move-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ALSA: opl4: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/e19de389484090a3059d17584d5a342db90889e5.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/opl4/opl4_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/drivers/opl4/opl4_lib.c~alsa-opl4-move-inline-before-return-type sound/drivers/opl4/opl4_lib.c
--- a/sound/drivers/opl4/opl4_lib.c~alsa-opl4-move-inline-before-return-type
+++ a/sound/drivers/opl4/opl4_lib.c
@@ -29,7 +29,7 @@ MODULE_AUTHOR("Clemens Ladisch <clemens@
 MODULE_DESCRIPTION("OPL4 driver");
 MODULE_LICENSE("GPL");
 
-static void inline snd_opl4_wait(struct snd_opl4 *opl4)
+static inline void snd_opl4_wait(struct snd_opl4 *opl4)
 {
 	int timeout = 10;
 	while ((inb(opl4->fm_port) & OPL4_STATUS_BUSY) && --timeout > 0)
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

