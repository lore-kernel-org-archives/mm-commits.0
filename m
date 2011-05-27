From: akpm@linux-foundation.org
Subject: [merged] documentation-accounting-getdelaysc-fix-unused-var-warning.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:26 -0700
Message-ID: <201105271955.p4RJtVoT017459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204Ab1E0Tz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: justinmattock@gmail.com, balbir@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/accounting/getdelays.c: fix unused var warning
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-fix-unused-var-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/accounting/getdelays.c: fix unused var warning
From: "Justin P. Mattock" <justinmattock@gmail.com>

Documentation/accounting/getdelays.c: In function `main':
Documentation/accounting/getdelays.c:436:7: warning: variable `i' set but not used [-Wunused-but-set-variable]

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
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
