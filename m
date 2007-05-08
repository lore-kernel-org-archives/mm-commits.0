From: akpm@linux-foundation.org
Subject: + get_unmapped_area-remove-now-unused-ret-variable.patch added to -mm tree
Date: Tue, 08 May 2007 13:50:05 -0700
Message-ID: <200705082050.l48Ko5UM001274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934439AbXEHUuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, frederik.deweerdt@gmail.com


The patch titled
     get_unmapped_area: remove now unused ret variable
has been added to the -mm tree.  Its filename is
     get_unmapped_area-remove-now-unused-ret-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get_unmapped_area: remove now unused ret variable
From: Frederik Deweerdt <deweerdt@free.fr>

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN mm/mmap.c~get_unmapped_area-remove-now-unused-ret-variable mm/mmap.c
--- a/mm/mmap.c~get_unmapped_area-remove-now-unused-ret-variable
+++ a/mm/mmap.c
@@ -1390,7 +1390,6 @@ unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
-	unsigned long ret;
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long);
 
_

Patches currently in -mm which might be from deweerdt@free.fr are

get_unmapped_area-remove-now-unused-ret-variable.patch
revoke-core-code-do_revoke-error-handling.patch
reiser4-sb_sync_inodes.patch
