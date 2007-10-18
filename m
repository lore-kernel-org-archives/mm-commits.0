From: akpm@linux-foundation.org
Subject: - include-linux-typesh-in-if_fddih.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:10 -0700
Message-ID: <200710180656.l9I6uAlJ030681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763450AbXJRHQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, macro@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     include linux/types.h in if_fddi.h
has been removed from the -mm tree.  Its filename was
     include-linux-typesh-in-if_fddih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+)

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

origin.patch
keep-track-of-network-interface-renaming.patch
