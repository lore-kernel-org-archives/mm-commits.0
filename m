From: akpm@linux-foundation.org
Subject: + maintainers-move-atlx-discussions-to-netdev.patch added to -mm tree
Date: Thu, 16 Sep 2010 14:20:03 -0700
Message-ID: <201009162120.o8GLK3GL014156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab0IPVUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 17:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris.snook@gmail.com, davem@davemloft.net, jcliburn@gmail.com, jie.yang@atheros.com


The patch titled
     MAINTAINERS: move atlx discussions to netdev
has been added to the -mm tree.  Its filename is
     maintainers-move-atlx-discussions-to-netdev.patch

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
Subject: MAINTAINERS: move atlx discussions to netdev
From: Chris Snook <chris.snook@gmail.com>

The atlx drivers are sufficiently mature that we no longer need a separate
mailing list for them.  Move the discussion to netdev, so we can
decommission atl1-devel, which is now mostly spam.

Signed-off-by: Chris Snook <chris.snook@gmail.com>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Jie Yang <jie.yang@atheros.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-move-atlx-discussions-to-netdev MAINTAINERS
--- a/MAINTAINERS~maintainers-move-atlx-discussions-to-netdev
+++ a/MAINTAINERS
@@ -1142,7 +1142,7 @@ ATLX ETHERNET DRIVERS
 M:	Jay Cliburn <jcliburn@gmail.com>
 M:	Chris Snook <chris.snook@gmail.com>
 M:	Jie Yang <jie.yang@atheros.com>
-L:	atl1-devel@lists.sourceforge.net
+L:	netdev@vger.kernel.org
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
 S:	Maintained
_

Patches currently in -mm which might be from chris.snook@gmail.com are

maintainers-move-atlx-discussions-to-netdev.patch
linux-next.patch

