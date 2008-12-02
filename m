From: akpm@linux-foundation.org
Subject: + alim15x3-fix-sparse-warning.patch added to -mm tree
Date: Tue, 02 Dec 2008 12:02:00 -0800
Message-ID: <200812022002.mB2K20DK021117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYLBUCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 15:02:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net


The patch titled
     alim15x3: fix sparse warning
has been added to the -mm tree.  Its filename is
     alim15x3-fix-sparse-warning.patch

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
Subject: alim15x3: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warning:

  drivers/ide/alim15x3.c:594:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/alim15x3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/alim15x3.c~alim15x3-fix-sparse-warning drivers/ide/alim15x3.c
--- a/drivers/ide/alim15x3.c~alim15x3-fix-sparse-warning
+++ a/drivers/ide/alim15x3.c
@@ -591,7 +591,7 @@ static int __init ali15x3_ide_init(void)
 
 static void __exit ali15x3_ide_exit(void)
 {
-	return pci_unregister_driver(&alim15x3_pci_driver);
+	pci_unregister_driver(&alim15x3_pci_driver);
 }
 
 module_init(ali15x3_ide_init);
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch
alim15x3-fix-sparse-warning.patch
udf-fix-sparse-warnings.patch
hugetlb-fix-sparse-warnings.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

