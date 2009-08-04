From: akpm@linux-foundation.org
Subject: + maintainers-add-ipvs-include-files.patch added to -mm tree
Date: Tue, 04 Aug 2009 00:01:44 -0700
Message-ID: <200908040701.n7471irN001825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbZHDHCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 03:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heder@google.com, davem@davemloft.net, joe@perches.com


The patch titled
     MAINTAINERS: add IPVS include files
has been added to the -mm tree.  Its filename is
     maintainers-add-ipvs-include-files.patch

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
Subject: MAINTAINERS: add IPVS include files
From: Hannes Eder <heder@google.com>

Signed-off-by: Hannes Eder <heder@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-ipvs-include-files MAINTAINERS
--- a/MAINTAINERS~maintainers-add-ipvs-include-files
+++ a/MAINTAINERS
@@ -2799,6 +2799,8 @@ L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/ipvs-sysctl.txt
+F:	include/net/ip_vs.h
+F:	include/linux/ip_vs.h
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
_

Patches currently in -mm which might be from heder@google.com are

linux-next.patch
maintainers-add-ipvs-include-files.patch

