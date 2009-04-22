From: akpm@linux-foundation.org
Subject: [merged] uml-kill-a-kconfig-warning.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:42 -0700
Message-ID: <200904221830.n3MIUgsc006334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128AbZDVSeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     uml: kill a kconfig warning
has been removed from the -mm tree.  Its filename was
     uml-kill-a-kconfig-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: kill a kconfig warning
From: WANG Cong <xiyou.wangcong@gmail.com>

Got this warning from Kconfig:

   boolean symbol INPUT tested for 'm'? test forced to 'n'

because INPUT is tristate, not bool.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.rest |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.rest~uml-kill-a-kconfig-warning arch/um/Kconfig.rest
--- a/arch/um/Kconfig.rest~uml-kill-a-kconfig-warning
+++ a/arch/um/Kconfig.rest
@@ -36,7 +36,7 @@ source "drivers/leds/Kconfig"
 
 #This is just to shut up some Kconfig warnings, so no prompt.
 config INPUT
-	bool
+	tristate
 	default n
 
 source "arch/um/Kconfig.debug"
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch

