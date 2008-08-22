From: akpm@linux-foundation.org
Subject: + blackfin-fix-update-gitignore-files.patch added to -mm tree
Date: Fri, 22 Aug 2008 14:01:15 -0700
Message-ID: <200808222101.m7ML1F4O016383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYHVVBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 17:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     Blackfin: fix/update .gitignore files
has been added to the -mm tree.  Its filename is
     blackfin-fix-update-gitignore-files.patch

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
Subject: Blackfin: fix/update .gitignore files
From: Mike Frysinger <vapier@gentoo.org>

Remove bogus leading "+".

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/boot/.gitignore   |    2 +-
 arch/blackfin/kernel/.gitignore |    1 +
 include/asm-blackfin/.gitignore |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/blackfin/boot/.gitignore~blackfin-fix-update-gitignore-files arch/blackfin/boot/.gitignore
--- a/arch/blackfin/boot/.gitignore~blackfin-fix-update-gitignore-files
+++ a/arch/blackfin/boot/.gitignore
@@ -1 +1 @@
-+vmImage
+vmImage
diff -puN /dev/null arch/blackfin/kernel/.gitignore
--- /dev/null
+++ a/arch/blackfin/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
diff -puN include/asm-blackfin/.gitignore~blackfin-fix-update-gitignore-files include/asm-blackfin/.gitignore
--- a/include/asm-blackfin/.gitignore~blackfin-fix-update-gitignore-files
+++ a/include/asm-blackfin/.gitignore
@@ -1 +1 @@
-+mach
+mach
_

Patches currently in -mm which might be from vapier@gentoo.org are

blackfin-fix-update-gitignore-files.patch

