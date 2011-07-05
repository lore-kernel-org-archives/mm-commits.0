From: akpm@linux-foundation.org
Subject: + maintainers-orphan-framerelay-dlci.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:00:25 -0700
Message-ID: <201107052100.p65L0P9E023663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab1GEVA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, davem@davemloft.net, shemminger@linux-foundation.org


The patch titled
     MAINTAINERS: orphan FrameRelay DLCI
has been added to the -mm tree.  Its filename is
     maintainers-orphan-framerelay-dlci.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: orphan FrameRelay DLCI
From: Joe Perches <joe@perches.com>

Mike McLagan hasn't contributed in many years and his email bounces.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-orphan-framerelay-dlci MAINTAINERS
--- a/MAINTAINERS~maintainers-orphan-framerelay-dlci
+++ a/MAINTAINERS
@@ -2626,9 +2626,8 @@ S:	Maintained
 F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
-M:	Mike McLagan <mike.mclagan@linux.org>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
get_maintainerspl-improve-mailmap-parsing.patch
maintainers-update-high-resolution-timers-patterns.patch
maintainers-remove-section-usb-se401-driver.patch
maintainers-orphan-framerelay-dlci.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
checkpatchpl-add-ability-to-ignore-various-messages.patch
checkpatch-make-utf-8-test-strict.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

