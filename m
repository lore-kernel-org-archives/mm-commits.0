From: akpm@linux-foundation.org
Subject: + fbcon-remove-stray-semicolons.patch added to -mm tree
Date: Fri, 18 Jul 2008 14:47:23 -0700
Message-ID: <200807182147.m6ILlN2Z032509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758522AbYGRVr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 17:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     fbcon: remove stray semicolons
has been added to the -mm tree.  Its filename is
     fbcon-remove-stray-semicolons.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: remove stray semicolons
From: "Jan Beulich" <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon.h~fbcon-remove-stray-semicolons drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-remove-stray-semicolons
+++ a/drivers/video/console/fbcon.h
@@ -147,9 +147,9 @@ static inline int attr_col_ec(int shift,
 }
 
 #define attr_bgcol_ec(bgshift,vc,info)		\
-	attr_col_ec(bgshift,vc,info,0);
+	attr_col_ec(bgshift,vc,info,0)
 #define attr_fgcol_ec(fgshift,vc,info)		\
-	attr_col_ec(fgshift,vc,info,1);
+	attr_col_ec(fgshift,vc,info,1)
 
 /* Font */
 #define REFCOUNT(fd)	(((int *)(fd))[-1])
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
linux-next.patch
acpi-fix-fadt-parsing.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
fbcon-remove-stray-semicolons.patch

