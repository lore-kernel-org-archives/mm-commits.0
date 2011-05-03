From: akpm@linux-foundation.org
Subject: + maintainers-remove-stale-reference-to-chris-wrights-lsm-tree.patch added to -mm tree
Date: Tue, 03 May 2011 14:03:07 -0700
Message-ID: <201105032103.p43L371X010133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754934Ab1ECVDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 17:03:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucian.grijincu@gmail.com, chrisw@sous-sol.org, jmorris@namei.org


The patch titled
     MAINTAINERS: remove stale reference to Chris Wright's LSM tree
has been added to the -mm tree.  Its filename is
     maintainers-remove-stale-reference-to-chris-wrights-lsm-tree.patch

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
Subject: MAINTAINERS: remove stale reference to Chris Wright's LSM tree
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

This tree hasn't been updated since June 2008.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-stale-reference-to-chris-wrights-lsm-tree MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-stale-reference-to-chris-wrights-lsm-tree
+++ a/MAINTAINERS
@@ -3911,7 +3911,6 @@ F:	drivers/*/*/*pasemi*
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 M:	Chris Wright <chrisw@sous-sol.org>
 L:	linux-security-module@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LIS3LV02D ACCELEROMETER DRIVER
_

Patches currently in -mm which might be from lucian.grijincu@gmail.com are

origin.patch
linux-next.patch
maintainers-remove-stale-reference-to-chris-wrights-lsm-tree.patch

