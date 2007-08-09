From: akpm@linux-foundation.org
Subject: + remove-consolemaph-from-header-exports.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:20:24 -0700
Message-ID: <200708092020.l79KKOxO017641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbXHIUVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de


The patch titled
     remove consolemap.h from header exports
has been added to the -mm tree.  Its filename is
     remove-consolemaph-from-header-exports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 deletion(-)

diff -puN include/linux/Kbuild~remove-consolemaph-from-header-exports include/linux/Kbuild
--- a/include/linux/Kbuild~remove-consolemaph-from-header-exports
+++ a/include/linux/Kbuild
@@ -45,7 +45,6 @@ header-y += chio.h
 header-y += coda_psdev.h
 header-y += coff.h
 header-y += comstats.h
-header-y += consolemap.h
 header-y += const.h
 header-y += cycx_cfm.h
 header-y += dlm_device.h
_

Patches currently in -mm which might be from olaf@aepfle.de are

unexport-asm-shmparamh.patch
remove-consolemaph-from-header-exports.patch
keep-track-of-network-interface-renaming.patch
