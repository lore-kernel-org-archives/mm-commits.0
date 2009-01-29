From: akpm@linux-foundation.org
Subject: + struct-linux_binprm-drop-unused-fields.patch added to -mm tree
Date: Wed, 28 Jan 2009 23:43:03 -0800
Message-ID: <200901290743.n0T7h3sq025919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZA2Hnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 02:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name


The patch titled
     struct linux_binprm: drop unused fields
has been added to the -mm tree.  Its filename is
     struct-linux_binprm-drop-unused-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

struct-linux_binprm-drop-unused-fields.patch

