From: akpm@linux-foundation.org
Subject: [merged] lxfb-add-copyright-license-info.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:57 -0800
Message-ID: <200912162035.nBGKZvC2013130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935405AbZLPUgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, jordan@cosmicpenguin.net, mm-commits@vger.kernel.org


The patch titled
     lxfb: add copyright/license info
has been removed from the -mm tree.  Its filename was
     lxfb-add-copyright-license-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: add copyright/license info
From: Andres Salomon <dilinger@collabora.co.uk>

The GRUB folks requested copyright/license info for lxfb.h, so here it is.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/video/geode/lxfb.h~lxfb-add-copyright-license-info drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-add-copyright-license-info
+++ a/drivers/video/geode/lxfb.h
@@ -1,3 +1,13 @@
+/* Geode LX framebuffer driver
+ *
+ * Copyright (C) 2006-2007, Advanced Micro Devices,Inc.
+ * Copyright (c) 2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
 #ifndef _LXFB_H_
 #define _LXFB_H_
 
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

origin.patch

