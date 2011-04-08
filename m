From: akpm@linux-foundation.org
Subject: + maintainers-update-stable-branch-info.patch added to -mm tree
Date: Fri, 08 Apr 2011 11:53:41 -0700
Message-ID: <201104081853.p38IrfLM023482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660Ab1DHSxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2011 14:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, chrisw@sous-sol.org, gregkh@suse.de


The patch titled
     MAINTAINERS: update STABLE BRANCH info
has been added to the -mm tree.  Its filename is
     maintainers-update-stable-branch-info.patch

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
Subject: MAINTAINERS: update STABLE BRANCH info
From: Randy Dunlap <randy.dunlap@oracle.com>

Drop Chris Wright from STABLE maintainers.  He hasn't done STABLE release
work for quite some time.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-stable-branch-info MAINTAINERS
--- a/MAINTAINERS~maintainers-update-stable-branch-info
+++ a/MAINTAINERS
@@ -5980,7 +5980,6 @@ F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
-M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mm-page_allocc-silence-build_all_zonelists-section-mismatch.patch
maintainers-update-stable-branch-info.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

