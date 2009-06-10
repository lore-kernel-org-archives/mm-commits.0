From: akpm@linux-foundation.org
Subject: [merged] gitignore-ignore-patch-files.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:29 -0700
Message-ID: <200906101756.n5AHuTot008516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbZFJR43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     .gitignore: ignore *.patch files
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-patch-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: .gitignore: ignore *.patch files
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-ignore-patch-files .gitignore
--- a/.gitignore~gitignore-ignore-patch-files
+++ a/.gitignore
@@ -25,6 +25,7 @@
 *.elf
 *.bin
 *.gz
+*.patch
 
 #
 # Top-level generic files
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
kmap_types-make-most-arches-use-generic-header-file.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

