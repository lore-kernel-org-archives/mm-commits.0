From: akpm@linux-foundation.org
Subject: + documentation-ignore-byproducts-from-latex.patch added to -mm tree
Date: Fri, 30 Jan 2009 11:27:02 -0800
Message-ID: <200901301927.n0UJR225010624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbZA3T1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henrik@austad.us, randy.dunlap@oracle.com


The patch titled
     documentation: ignore byproducts from latex
has been added to the -mm tree.  Its filename is
     documentation-ignore-byproducts-from-latex.patch

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
Subject: documentation: ignore byproducts from latex
From: Henrik Austad <henrik@austad.us>

When using 'make pdfdocs', auto-generated files should be ignored

Signed-off-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/.gitignore |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/DocBook/.gitignore~documentation-ignore-byproducts-from-latex Documentation/DocBook/.gitignore
--- a/Documentation/DocBook/.gitignore~documentation-ignore-byproducts-from-latex
+++ a/Documentation/DocBook/.gitignore
@@ -4,3 +4,7 @@
 *.html
 *.9.gz
 *.9
+*.aux
+*.dvi
+*.log
+*.out
_

Patches currently in -mm which might be from henrik@austad.us are

documentation-ignore-byproducts-from-latex.patch

