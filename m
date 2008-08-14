From: akpm@linux-foundation.org
Subject: + maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp.patch added to -mm tree
Date: Thu, 14 Aug 2008 02:02:36 -0700
Message-ID: <200808140902.m7E92aSv000536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbYHNJCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 05:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, sfr@canb.auug.org.au


The patch titled
     MAINTAINERS: add maintainers for GRU, XPC, XPNET and XP
has been added to the -mm tree.  Its filename is
     maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp.patch

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
Subject: MAINTAINERS: add maintainers for GRU, XPC, XPNET and XP
From: Jack Steiner <steiner@sgi.com>

Add MAINTAINERS for GRU, XPNET, XPC and XP drivers.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN MAINTAINERS~maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp
+++ a/MAINTAINERS
@@ -3763,6 +3763,16 @@ L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 
+SGI GRU DRIVER
+P:	Jack Steiner
+M:	steiner@sgi.com
+S:	Maintained
+
+SGI XP/XPC/XPNET DRIVER
+P:	Dean Nelson
+M:	dcn@sgi.com
+S:	Maintained
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
_

Patches currently in -mm which might be from steiner@sgi.com are

maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp.patch
linux-next.patch

