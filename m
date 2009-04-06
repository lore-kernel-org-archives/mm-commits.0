From: akpm@linux-foundation.org
Subject: [merged] struct-linux_binprm-drop-unused-fields.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:12 -0700
Message-ID: <200904061936.n36JaCn3012356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbZDFThf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     struct linux_binprm: drop unused fields
has been removed from the -mm tree.  Its filename was
     struct-linux_binprm-drop-unused-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: struct linux_binprm: drop unused fields
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/binfmts.h~struct-linux_binprm-drop-unused-fields include/linux/binfmts.h
--- a/include/linux/binfmts.h~struct-linux_binprm-drop-unused-fields
+++ a/include/linux/binfmts.h
@@ -35,8 +35,7 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	unsigned int sh_bang:1,
-		misc_bang:1,
+	unsigned int
 		cred_prepared:1,/* true if creds already prepared (multiple
 				 * preps happen for interpreters) */
 		cap_effective:1;/* true if has elevated effective capabilities,
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

