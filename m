From: akpm@linux-foundation.org
Subject: + fbdev-blackfin-has-__raw-i-o-accessors-so-use-them-in-fbh.patch added to -mm tree
Date: Mon, 15 Jun 2009 13:04:52 -0700
Message-ID: <200906152004.n5FK4qvN014538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbZFOUE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 16:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, krzysztof.h1@poczta.fm


The patch titled
     fbdev: blackfin has __raw I/O accessors, so use them in fb.h
has been added to the -mm tree.  Its filename is
     fbdev-blackfin-has-__raw-i-o-accessors-so-use-them-in-fbh.patch

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
Subject: fbdev: blackfin has __raw I/O accessors, so use them in fb.h
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fb.h~fbdev-blackfin-has-__raw-i-o-accessors-so-use-them-in-fbh include/linux/fb.h
--- a/include/linux/fb.h~fbdev-blackfin-has-__raw-i-o-accessors-so-use-them-in-fbh
+++ a/include/linux/fb.h
@@ -903,7 +903,7 @@ struct fb_info {
 #define fb_writeq sbus_writeq
 #define fb_memset sbus_memset_io
 
-#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__)
+#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__) || defined(__bfin__)
 
 #define fb_readb __raw_readb
 #define fb_readw __raw_readw
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
kmap_types-make-most-arches-use-generic-header-file.patch
ramfs-ignore-unknown-mount-options.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
fbdev-blackfin-has-__raw-i-o-accessors-so-use-them-in-fbh.patch
fbdev-bfin-t350mcqb-fb-drop-unused-local-variables.patch
fbdev-bfin-drop-unnecessary-calls-to-memset.patch
fbdev-bfin-fix-__devinitexit-markings.patch
fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

