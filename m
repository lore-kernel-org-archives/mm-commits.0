From: akpm@linux-foundation.org
Subject: - check-for-ppc32-in-imsttfb.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:09 -0700
Message-ID: <200708242057.l7OKv9uT014136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764018AbXHXVIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, adaplas@pol.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Check for PPC32 in imsttfb
has been removed from the -mm tree.  Its filename was
     check-for-ppc32-in-imsttfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Check for PPC32 in imsttfb
From: Stephen Rothwell <sfr@canb.auug.org.au>

This is the correct fix according to Paul Mackerras and allows an
allyesconfig on PPC64 to build.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imsttfb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/imsttfb.c~check-for-ppc32-in-imsttfb drivers/video/imsttfb.c
--- a/drivers/video/imsttfb.c~check-for-ppc32-in-imsttfb
+++ a/drivers/video/imsttfb.c
@@ -1391,7 +1391,7 @@ init_imstt(struct fb_info *info)
 		}
 	}
 
-#if USE_NV_MODES && defined(CONFIG_PPC)
+#if USE_NV_MODES && defined(CONFIG_PPC32)
 	{
 		int vmode = init_vmode, cmode = init_cmode;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
git-alsa.patch
git-powerpc.patch
allow-disabling-dnotify-without-embedded.patch
