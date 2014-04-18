From: akpm@linux-foundation.org
Subject: + fs-binfmt_flatc-make-old_reloc-static.patch added to -mm tree
Date: Fri, 18 Apr 2014 15:23:47 -0700
Message-ID: <5351a5f3.rKxUHGaFr1/1NXiB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaDRWXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axel.lin@ingics.com

Subject: + fs-binfmt_flatc-make-old_reloc-static.patch added to -mm tree
To: axel.lin@ingics.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:23:47 -0700


The patch titled
     Subject: fs/binfmt_flat.c: make old_reloc() static
has been added to the -mm tree.  Its filename is
     fs-binfmt_flatc-make-old_reloc-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_flatc-make-old_reloc-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_flatc-make-old_reloc-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-binfmt_flatc-make-old_reloc-static.patch
linux-next.patch

