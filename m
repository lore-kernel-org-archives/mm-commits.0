From: akpm@linux-foundation.org
Subject: - blackfin-add-include-boot-gitignore-files.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:55 -0700
Message-ID: <200804261641.m3QGftfj031160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757689AbYDZQt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin: add include/boot .gitignore files
has been removed from the -mm tree.  Its filename was
     blackfin-add-include-boot-gitignore-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: add include/boot .gitignore files
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/boot/.gitignore   |    1 +
 include/asm-blackfin/.gitignore |    1 +
 2 files changed, 2 insertions(+)

diff -puN /dev/null arch/blackfin/boot/.gitignore
--- /dev/null
+++ a/arch/blackfin/boot/.gitignore
@@ -0,0 +1 @@
+vmImage
diff -puN /dev/null include/asm-blackfin/.gitignore
--- /dev/null
+++ a/include/asm-blackfin/.gitignore
@@ -0,0 +1 @@
+mach
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
remove-duplicated-unlikely-in-is_err.patch

