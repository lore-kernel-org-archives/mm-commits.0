From: akpm@linux-foundation.org
Subject: + blackfin-add-include-boot-gitignore-files.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:57:59 -0700
Message-ID: <200804172157.m3HLvxX0029850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbYDQV6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     blackfin: add include/boot .gitignore files
has been added to the -mm tree.  Its filename is
     blackfin-add-include-boot-gitignore-files.patch

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

git-hid.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
blackfin-add-include-boot-gitignore-files.patch
remove-duplicated-unlikely-in-is_err.patch

