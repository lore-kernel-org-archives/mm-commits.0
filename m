From: akpm@linux-foundation.org
Subject: + scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:55:22 -0700
Message-ID: <200807292255.m6TMtMja026222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbYG2W4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     scripts/mod/modpost.c: fix spelling of module and happens
has been added to the -mm tree.  Its filename is
     scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch

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

backlight-give-platform_lcd-the-same-name-as-the-platform-device.patch
resource-add-resource_size.patch
backlight-ensure-platform_lcd-on-by-default.patch
scripts-mod-modpostc-fix-spelling-of-module-and-happens.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

