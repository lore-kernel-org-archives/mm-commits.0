From: akpm@linux-foundation.org
Subject: [merged] gitignore-add-bzip2-compressed-files.patch removed from -mm tree
Date: Tue, 01 Dec 2009 12:18:02 -0800
Message-ID: <200912012018.nB1KI2nZ019969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbZLAUR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 15:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gwingerde@gmail.com, mm-commits@vger.kernel.org


The patch titled
     .gitignore: add bzip2 compressed files
has been removed from the -mm tree.  Its filename was
     gitignore-add-bzip2-compressed-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

