From: akpm@linux-foundation.org
Subject: + s3c2443-ac97-compilation-fix.patch added to -mm tree
Date: Thu, 18 Oct 2007 13:58:17 -0700
Message-ID: <200710182058.l9IKwHDF030763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbXJRU62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 16:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, perex@suse.cz, tiwai@suse.de


The patch titled
     s3c2443-ac97: compilation fix
has been added to the -mm tree.  Its filename is
     s3c2443-ac97-compilation-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2443-ac97: compilation fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The Samsung S3C24xx uses new architecture file layout in the post 2.6.23
kernel.  This patch fixes include path for the s3c2443-ac97.c.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/s3c24xx/s3c2443-ac97.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/soc/s3c24xx/s3c2443-ac97.c~s3c2443-ac97-compilation-fix sound/soc/s3c24xx/s3c2443-ac97.c
--- a/sound/soc/s3c24xx/s3c2443-ac97.c~s3c2443-ac97-compilation-fix
+++ a/sound/soc/s3c24xx/s3c2443-ac97.c
@@ -32,7 +32,7 @@
 
 #include <asm/hardware.h>
 #include <asm/io.h>
-#include <asm/arch/regs-ac97.h>
+#include <asm/plat-s3c/regs-ac97.h>
 #include <asm/arch/regs-gpio.h>
 #include <asm/arch/regs-clock.h>
 #include <asm/arch/audio.h>
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
s3c2443-ac97-compilation-fix.patch
cyber2000fb-checkpatch-fixes.patch
