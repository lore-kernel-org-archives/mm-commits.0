From: akpm@linux-foundation.org
Subject: - lxfb-drop-dead-declarations-from-header.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:03 -0700
Message-ID: <200807242333.m6ONX3oj011896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689AbYGXXdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     lxfb: drop dead declarations from header
has been removed from the -mm tree.  Its filename was
     lxfb-drop-dead-declarations-from-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: drop dead declarations from header
From: Andres Salomon <dilinger@queued.net>

We never sent the gamma stuff upstream, and don't really care about it. 
However, lx_[gs]_et_gamma prototypes snuck into lxfb.h anyways; there are
no definitions for them.  Drop the dead code.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-drop-dead-declarations-from-header drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-drop-dead-declarations-from-header
+++ a/drivers/video/geode/lxfb.h
@@ -51,8 +51,6 @@ static inline unsigned int lx_get_pitch(
 }
 
 void lx_set_mode(struct fb_info *);
-void lx_get_gamma(struct fb_info *, unsigned int *, int);
-void lx_set_gamma(struct fb_info *, unsigned int *, int);
 unsigned int lx_framebuffer_size(void);
 int lx_blank_display(struct fb_info *, int);
 void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
linux-next.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch

