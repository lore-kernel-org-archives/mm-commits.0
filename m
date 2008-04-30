From: akpm@linux-foundation.org
Subject: + embedded-maintainers-linux-embedded-vger-list.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:57:11 -0700
Message-ID: <200804301757.m3UHvBmJ027082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbYD3R5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, paul.gortmaker@windriver.com


The patch titled
     Embedded Maintainer(s), linux-embedded@vger list
has been added to the -mm tree.  Its filename is
     embedded-maintainers-linux-embedded-vger-list.patch

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
Subject: Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>

Add Paul and myself, and the linux-embedded list, to MAINTAINERS.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~embedded-maintainers-linux-embedded-vger-list MAINTAINERS
--- a/MAINTAINERS~embedded-maintainers-linux-embedded-vger-list
+++ a/MAINTAINERS
@@ -1562,6 +1562,14 @@ M:	raisch@de.ibm.com
 L:	general@lists.openfabrics.org
 S:	Supported
 
+EMBEDDED LINUX
+P:	Paul Gortmaker
+M:	paul.gortmaker@windriver.com
+P	David Woodhouse
+M:	dwmw2@infradead.org
+L:	linux-embedded@vger.kernel.org
+S:	Maintained
+
 EMULEX LPFC FC SCSI DRIVER
 P:	James Smart
 M:	james.smart@emulex.com
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
git-mtd.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
embedded-maintainers-linux-embedded-vger-list.patch

