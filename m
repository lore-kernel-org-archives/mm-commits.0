From: akpm@linux-foundation.org
Subject: + maintainers-update-bna-10g-maintainer.patch added to -mm tree
Date: Tue, 30 Aug 2011 14:14:02 -0700
Message-ID: <201108302114.p7ULE2O6017540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756733Ab1H3VOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 17:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, joe@perches.com, rmody@brocade.com


The patch titled
     MAINTAINERS: update BNA 10G Maintainer
has been added to the -mm tree.  Its filename is
     maintainers-update-bna-10g-maintainer.patch

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
Subject: MAINTAINERS: update BNA 10G Maintainer
From: Ian Campbell <ian.campbell@citrix.com>

ddutt@brocade.com bounces with 550 "RESOLVER.ADR.RecipNotFound"

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rasesh Mody <rmody@brocade.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-bna-10g-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-update-bna-10g-maintainer
+++ a/MAINTAINERS
@@ -1574,7 +1574,6 @@ F:	drivers/scsi/bfa/
 
 BROCADE BNA 10 GIGABIT ETHERNET DRIVER
 M:	Rasesh Mody <rmody@brocade.com>
-M:	Debashis Dutt <ddutt@brocade.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/brocade/bna/
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

linux-next.patch
maintainers-update-bna-10g-maintainer.patch

