From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-arch-independent-testcases-for-rodata-fix.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 14:21:27 -0800
Message-ID: <58b4a667.G8aJAomiK9cV7gSZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdB0WV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jinb.park7@gmail.com, keescook@chromium.org, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: testcases for RODATA: fix config dependency
has been removed from the -mm tree.  Its filename was
     mm-add-arch-independent-testcases-for-rodata-fix.patch

This patch was dropped because it was folded into mm-add-arch-independent-testcases-for-rodata.patch

------------------------------------------------------
From: Jinbum Park <jinb.park7@gmail.com>
Subject: mm: testcases for RODATA: fix config dependency

Since DEBUG_RODATA has renamed to STRICT_KERNEL_RWX,
Fix the config dependency.

Link: http://lkml.kernel.org/r/20170209131625.GA16954@pjb1027-Latitude-E5410
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata-fix mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata-fix
+++ a/mm/Kconfig.debug
@@ -93,7 +93,7 @@ config DEBUG_PAGE_REF
 
 config DEBUG_RODATA_TEST
     bool "Testcase for the marking rodata read-only"
-    depends on DEBUG_RODATA
+    depends on STRICT_KERNEL_RWX
     ---help---
       This option enables a testcase for the setting rodata read-only.
 
_

Patches currently in -mm which might be from jinb.park7@gmail.com are

scripts-spellingtxt-add-some-typo-words.patch
mm-add-arch-independent-testcases-for-rodata.patch

