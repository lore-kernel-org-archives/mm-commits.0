From: akpm@linux-foundation.org
Subject: - drivers-video-remove-include-versionh.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:43:22 -0700
Message-ID: <200808261843.m7QIhMcT021288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290AbYHZSoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, krzysztof.h1@poczta.fm, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/: remove #include <version.h>
has been removed from the -mm tree.  Its filename was
     drivers-video-remove-include-versionh.patch

This patch was dropped because an alternative patch was merged

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
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch
drivers-video-remove-include-versionh.patch

