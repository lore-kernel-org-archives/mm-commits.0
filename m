From: akpm@linux-foundation.org
Subject: + documentation-accounting-getdelaysc-fix-unused-var-warning.patch added to -mm tree
Date: Tue, 12 Apr 2011 17:21:48 -0700
Message-ID: <201104130021.p3D0Lm7I011664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab1DMAWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 20:22:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: justinmattock@gmail.com


The patch titled
     Documentation/accounting/getdelays.c: fix unused var warning
has been added to the -mm tree.  Its filename is
     documentation-accounting-getdelaysc-fix-unused-var-warning.patch

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
Subject: Documentation/accounting/getdelays.c: fix unused var warning
From: "Justin P. Mattock" <justinmattock@gmail.com>

Documentation/accounting/getdelays.c: In function `main':
Documentation/accounting/getdelays.c:436:7: warning: variable `i' set but not used [-Wunused-but-set-variable]

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-fix-unused-var-warning Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-fix-unused-var-warning
+++ a/Documentation/accounting/getdelays.c
@@ -433,8 +433,6 @@ int main(int argc, char *argv[])
 	}
 
 	do {
-		int i;
