From: akpm@linux-foundation.org
Subject: [merged] gitignore-ignore-kconfig-i18n-files.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:47:48 -0700
Message-ID: <200906101747.n5AHlmOK001462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbZFJRup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     gitignore: ignore Kconfig i18n files
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-kconfig-i18n-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gitignore: ignore Kconfig i18n files
From: Markus Heidelberg <markus.heidelberg@web.de>

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/.gitignore |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/kconfig/.gitignore~gitignore-ignore-kconfig-i18n-files scripts/kconfig/.gitignore
--- a/scripts/kconfig/.gitignore~gitignore-ignore-kconfig-i18n-files
+++ a/scripts/kconfig/.gitignore
@@ -8,6 +8,9 @@ lex.*.c
 zconf.hash.c
 *.moc
 lkc_defs.h
+gconf.glade.h
+*.pot
+*.mo
 
 #
 # configuration programs
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

linux-next.patch

