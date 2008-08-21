From: akpm@linux-foundation.org
Subject: + drivers-video-remove-include-versionh.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:31:02 -0700
Message-ID: <200808211931.m7LJV2Zc021963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbYHUTbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, krzysztof.h1@poczta.fm, santiago@crfreenet.org


The patch titled
     drivers/video/: remove #include <version.h>
has been added to the -mm tree.  Its filename is
     drivers-video-remove-include-versionh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/: remove #include <version.h>
From: Huang Weiyi <weiyi.huang@gmail.com>

The driver(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/video/arkfb.c
  drivers/video/s3fb.c
  drivers/video/vt8623fb.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c    |    1 -
 drivers/video/s3fb.c     |    1 -
 drivers/video/vt8623fb.c |    1 -
 3 files changed, 3 deletions(-)

diff -puN drivers/video/arkfb.c~drivers-video-remove-include-versionh drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~drivers-video-remove-include-versionh
+++ a/drivers/video/arkfb.c
@@ -11,7 +11,6 @@
  *  Code is based on s3fb
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff -puN drivers/video/s3fb.c~drivers-video-remove-include-versionh drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~drivers-video-remove-include-versionh
+++ a/drivers/video/s3fb.c
@@ -11,7 +11,6 @@
  * which is based on the code of neofb.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff -puN drivers/video/vt8623fb.c~drivers-video-remove-include-versionh drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~drivers-video-remove-include-versionh
+++ a/drivers/video/vt8623fb.c
@@ -12,7 +12,6 @@
  * (http://davesdomain.org.uk/viafb/)
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-x86-kernel-apm_32c-remove-duplicated-include.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch
drivers-misc-eeprom_93cx6c-remove-include-versionh.patch
drivers-video-remove-include-versionh.patch

