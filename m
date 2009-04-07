From: akpm@linux-foundation.org
Subject: + sgi-xpc-update-sgi-xp-xpc-xpnet-maintainer.patch added to -mm tree
Date: Tue, 07 Apr 2009 12:52:05 -0700
Message-ID: <200904071952.n37Jq6GD030210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbZDGTxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com


The patch titled
     sgi-xpc: update SGI XP/XPC/XPNET maintainer
has been added to the -mm tree.  Its filename is
     sgi-xpc-update-sgi-xp-xpc-xpnet-maintainer.patch

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
Subject: sgi-xpc: update SGI XP/XPC/XPNET maintainer
From: Robin Holt <holt@sgi.com>

Dean has moved on to other work.  His responsibilities for XP/XPC/XPNET
have been handed to me.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~sgi-xpc-update-sgi-xp-xpc-xpnet-maintainer MAINTAINERS
--- a/MAINTAINERS~sgi-xpc-update-sgi-xp-xpc-xpnet-maintainer
+++ a/MAINTAINERS
@@ -4031,8 +4031,8 @@ W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 
 SGI XP/XPC/XPNET DRIVER
-P:	Dean Nelson
-M:	dcn@sgi.com
+P:	Robin Holt
+M:	holt@sgi.com
 S:	Maintained
 
 SHARP LH SUPPORT (LH7952X & LH7A40X)
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
sgi-xpc-update-sgi-xp-xpc-xpnet-maintainer.patch
sgi-xpc-prevent-false-heartbeat-failures.patch
sgi-xpc-implement-opencomplete-messaging.patch

