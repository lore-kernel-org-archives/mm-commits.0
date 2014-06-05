From: akpm@linux-foundation.org
Subject: [merged] fs-binfmt_flatc-make-old_reloc-static.patch removed from -mm tree
Date: Thu, 05 Jun 2014 13:07:33 -0700
Message-ID: <5390ce05.o46Hyr13yZNH8e4z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFEUHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axel.lin@ingics.com

Subject: [merged] fs-binfmt_flatc-make-old_reloc-static.patch removed from -mm tree
To: axel.lin@ingics.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:07:33 -0700


The patch titled
     Subject: fs/binfmt_flat.c: make old_reloc() static
has been removed from the -mm tree.  Its filename was
     fs-binfmt_flatc-make-old_reloc-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: fs/binfmt_flat.c: make old_reloc() static

old_reloc() is only used in this file, make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_flat.c~fs-binfmt_flatc-make-old_reloc-static fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~fs-binfmt_flatc-make-old_reloc-static
+++ a/fs/binfmt_flat.c
@@ -380,7 +380,7 @@ failed:
 
 /****************************************************************************/
 
-void old_reloc(unsigned long rl)
+static void old_reloc(unsigned long rl)
 {
 #ifdef DEBUG
 	char *segment[] = { "TEXT", "DATA", "BSS", "*UNKNOWN*" };
_

Patches currently in -mm which might be from axel.lin@ingics.com are

origin.patch
linux-next.patch

