From: akpm@linux-foundation.org
Subject: + gitignore-add-bzip2-compressed-files.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:56:30 -0800
Message-ID: <200911242056.nAOKuUhm029755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932823AbZKXU40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gwingerde@gmail.com


The patch titled
     .gitignore: add bzip2 compressed files
has been added to the -mm tree.  Its filename is
     gitignore-add-bzip2-compressed-files.patch

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
Subject: .gitignore: add bzip2 compressed files
From: Gertjan van Wingerde <gwingerde@gmail.com>

We can have bzip2 compressed images nowadays.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-add-bzip2-compressed-files .gitignore
--- a/.gitignore~gitignore-add-bzip2-compressed-files
+++ a/.gitignore
@@ -26,6 +26,7 @@ modules.builtin
 *.elf
 *.bin
 *.gz
+*.bz2
 *.lzma
 *.patch
 *.gcno
_

Patches currently in -mm which might be from gwingerde@gmail.com are

linux-next.patch
gitignore-add-bzip2-compressed-files.patch

