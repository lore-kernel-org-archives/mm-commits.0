From: akpm@linux-foundation.org
Subject: - blackfin-fix-update-gitignore-files.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:45:36 -0700
Message-ID: <200808282145.m7SLjakI015972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbYH1Vpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin: fix/update .gitignore files
has been removed from the -mm tree.  Its filename was
     blackfin-fix-update-gitignore-files.patch

This patch was dropped because include/asm-blackfin/.gitignore vanished from linux-next

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

setlocalversion-dont-include-svn-change-count.patch
blackfin-fix-update-gitignore-files.patch

