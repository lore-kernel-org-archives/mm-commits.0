From: akpm@linux-foundation.org
Subject: + documentation-arm-00-index-add-missing-entries.patch added to -mm tree
Date: Fri, 31 Aug 2007 13:02:58 -0700
Message-ID: <200708312003.l7VK30fn024172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761009AbXHaUDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 16:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net


The patch titled
     Documentation/arm/00-INDEX: add missing entries
has been added to the -mm tree.  Its filename is
     documentation-arm-00-index-add-missing-entries.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/arm/00-INDEX: add missing entries
From: Rob Landley <rob@landley.net>

Index two unindexed documentation files.

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/arm/00-INDEX |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN Documentation/arm/00-INDEX~documentation-arm-00-index-add-missing-entries Documentation/arm/00-INDEX
--- a/Documentation/arm/00-INDEX~documentation-arm-00-index-add-missing-entries
+++ a/Documentation/arm/00-INDEX
@@ -20,3 +20,7 @@ memory.txt
 	- description of the virtual memory layout
 nwfpe
 	- NWFPE floating point emulator documentation
+Porting
+	- Symbol definitions for porting Linux to a new ARM machine.
+Setup
+	- Kernel initialization parameters on ARM Linux
_

Patches currently in -mm which might be from rob@landley.net are

docs-ramdisk-initrd-initramfs-corrections.patch
documentation-arm-00-index-add-missing-entries.patch
documentation-make-headers_installtxt.patch
