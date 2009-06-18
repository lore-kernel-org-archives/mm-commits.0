From: akpm@linux-foundation.org
Subject: + maintainers-update-wirelessh-path.patch added to -mm tree
Date: Thu, 18 Jun 2009 16:34:38 -0700
Message-ID: <200906182334.n5INYcHQ018100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbZFRXfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 19:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, linville@tuxdriver.com


The patch titled
     MAINTAINERS: update wireless.h path
has been added to the -mm tree.  Its filename is
     maintainers-update-wirelessh-path.patch

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
Subject: MAINTAINERS: update wireless.h path
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-wirelessh-path MAINTAINERS
--- a/MAINTAINERS~maintainers-update-wirelessh-path
+++ a/MAINTAINERS
@@ -4083,7 +4083,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	net/wireless/
 F:	include/net/ieee80211*
-F:	include/net/wireless.h
+F:	include/linux/wireless.h
 
 NETWORKING DRIVERS
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
bootmemc-avoid-c90-declaration-warning.patch
bootmemc-avoid-c90-declaration-warning-cleanup.patch
maintainers-pair-names-addresses-in-edac-i82975x.patch
maintainers-fix-atheros-pattern-paths.patch
maintainers-update-ftrace-documentation-pattern.patch
maintainers-update-wirelessh-path.patch
maintainers-ieee802154-fix-pattern-typo.patch
maintainers-kmemtrace-pattern-update.patch
linux-next.patch

