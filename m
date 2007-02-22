From: akpm@linux-foundation.org
Subject: + remove-outdated-information-from-kconfig.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:32:14 -0800
Message-ID: <200702220032.l1M0WECO031340@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422840AbXBVAcZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:32:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     ipx: remove outdated information from Kconfig
has been added to the -mm tree.  Its filename is
     remove-outdated-information-from-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipx: remove outdated information from Kconfig
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

SPX was removed in early 2.5.  How to connect to a Mac or the other OS isn't
hard to find out these days.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipx/Kconfig |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN net/ipx/Kconfig~remove-outdated-information-from-kconfig net/ipx/Kconfig
--- a/net/ipx/Kconfig~remove-outdated-information-from-kconfig
+++ a/net/ipx/Kconfig
@@ -16,8 +16,7 @@ config IPX
 	  support", below.
 
 	  IPX is similar in scope to IP, while SPX, which runs on top of IPX,
-	  is similar to TCP. There is also experimental support for SPX in
-	  Linux (see "SPX networking", below).
+	  is similar to TCP.
 
 	  To turn your Linux box into a fully featured NetWare file server and
 	  IPX router, say Y here and fetch either lwared from
@@ -26,9 +25,6 @@ config IPX
 	  information, read the IPX-HOWTO available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
-
 	  The IPX driver would enlarge your kernel by about 16 KB. To compile
 	  this driver as a module, choose M here: the module will be called ipx.
 	  Unless you want to integrate your Linux box with a local Novell
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

remove-outdated-information-from-kconfig.patch
remove-ancient-changelog.patch
