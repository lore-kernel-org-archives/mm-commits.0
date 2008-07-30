From: akpm@linux-foundation.org
Subject: - scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:24 -0700
Message-ID: <200807301915.m6UJFOWk011022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbYG3TQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/mod/modpost.c: fix spelling of module and happens
has been removed from the -mm tree.  Its filename was
     scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/mod/modpost.c: fix spelling of module and happens
From: Ben Dooks <ben-linux@fluff.org>

Spelling fixes in scripts/mod/modpost.c

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~scripts-mod-modpostc-fix-spelling-of-module-and-happens scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~scripts-mod-modpostc-fix-spelling-of-module-and-happens
+++ a/scripts/mod/modpost.c
@@ -1468,7 +1468,7 @@ static void section_rel(const char *modn
  * marked __initdata will be discarded when the module has been intialized.
  * Likewise for modules used built-in the sections marked __exit
  * are discarded because __exit marked function are supposed to be called
- * only when a moduel is unloaded which never happes for built-in modules.
+ * only when a module is unloaded which never happens for built-in modules.
  * The check_sec_ref() function traverses all relocation records
  * to find all references to a section that reference a section that will
  * be discarded and warns about it.
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
backlight-add-more-information-output-to-pwm_backlight.patch
backlight-add-module_alias-to-pwm_backlight-driver.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

