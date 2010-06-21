From: akpm@linux-foundation.org
Subject: + maintainers-update-information-about-linux-test-project-maintainence.patch added to -mm tree
Date: Mon, 21 Jun 2010 14:31:23 -0700
Message-ID: <201006212131.o5LLVNo2006028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758444Ab0FUVbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 17:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: subrata@linux.vnet.ibm.com


The patch titled
     MAINTAINERS: update information about Linux Test Project maintainence
has been added to the -mm tree.  Its filename is
     maintainers-update-information-about-linux-test-project-maintainence.patch

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
Subject: MAINTAINERS: update information about Linux Test Project maintainence
From: Subrata Modak <subrata@linux.vnet.ibm.com>

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS      |    2 +-
 MAINTAINERS.orig |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-information-about-linux-test-project-maintainence MAINTAINERS
--- a/MAINTAINERS~maintainers-update-information-about-linux-test-project-maintainence
+++ a/MAINTAINERS
@@ -3609,7 +3609,7 @@ M:	Mike Frysinger <vapier@gentoo.org>
 M:	Subrata Modak <subrata@linux.vnet.ibm.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
+T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
 M32R ARCHITECTURE
diff -puN MAINTAINERS.orig~maintainers-update-information-about-linux-test-project-maintainence MAINTAINERS.orig
--- a/MAINTAINERS.orig~maintainers-update-information-about-linux-test-project-maintainence
+++ a/MAINTAINERS.orig
@@ -6296,6 +6296,11 @@ M:	linux-wimax@intel.com
 L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
+F:	Documentation/wimax/README.wimax
+F:	include/linux/wimax.h
+F:	include/linux/wimax/debug.h
+F:	include/net/wimax.h
+F:	net/wimax/
 
 WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
 M:	David Vrabel <david.vrabel@csr.com>
_

Patches currently in -mm which might be from subrata@linux.vnet.ibm.com are

maintainers-update-information-about-linux-test-project-maintainence.patch

