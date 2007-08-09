From: akpm@linux-foundation.org
Subject: + include-linux-typesh-in-if_fddih.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:50:21 -0700
Message-ID: <200708092150.l79LoLv3021342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbXHIVum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, macro@linux-mips.org


The patch titled
     include linux/types.h in if_fddi.h
has been added to the -mm tree.  Its filename is
     include-linux-typesh-in-if_fddih.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: include linux/types.h in if_fddi.h
From: Olaf Hering <olaf@aepfle.de>

include/linux/if_fddi.h is an exported header.
It uses __be16. Include linux/types.h to get this prototype.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/if_fddi.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/linux/if_fddi.h~include-linux-typesh-in-if_fddih include/linux/if_fddi.h
--- a/include/linux/if_fddi.h~include-linux-typesh-in-if_fddih
+++ a/include/linux/if_fddi.h
@@ -24,6 +24,8 @@
 #ifndef _LINUX_IF_FDDI_H
 #define _LINUX_IF_FDDI_H
 
+#include <linux/types.h>
+
 /*
  *  Define max and min legal sizes.  The frame sizes do not include
  *  4 byte FCS/CRC (frame check sequence).
_

Patches currently in -mm which might be from olaf@aepfle.de are

unexport-asm-shmparamh.patch
remove-consolemaph-from-header-exports.patch
include-linux-typesh-in-if_fddih.patch
keep-track-of-network-interface-renaming.patch
