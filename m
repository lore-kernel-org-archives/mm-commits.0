From: akpm@linux-foundation.org
Subject: - remove-consolemaph-from-header-exports.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:57 -0700
Message-ID: <200710180655.l9I6tvpK030657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760466AbXJRHPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     remove consolemap.h from header exports
has been removed from the -mm tree.  Its filename was
     remove-consolemaph-from-header-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove consolemap.h from header exports
From: Olaf Hering <olaf@aepfle.de>

Remove linux/consolemap.h from make headers_install

It contains no user interfaces.
The defines in this file are used only for kernel internal state.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/Kbuild~remove-consolemaph-from-header-exports include/linux/Kbuild
--- a/include/linux/Kbuild~remove-consolemaph-from-header-exports
+++ a/include/linux/Kbuild
@@ -46,7 +46,6 @@ header-y += chio.h
 header-y += coda_psdev.h
 header-y += coff.h
 header-y += comstats.h
-header-y += consolemap.h
 header-y += const.h
 header-y += cycx_cfm.h
 header-y += dlm_device.h
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
keep-track-of-network-interface-renaming.patch
