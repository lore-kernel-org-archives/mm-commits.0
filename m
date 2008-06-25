From: akpm@linux-foundation.org
Subject: + procfs-guide-drop-pointless-nbsp-entities.patch added to -mm tree
Date: Wed, 25 Jun 2008 16:28:14 -0700
Message-ID: <200806252328.m5PNSEuj032207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbYFYX2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 19:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, randy.dunlap@oracle.com


The patch titled
     procfs-guide: drop pointless &nbsp; entities
has been added to the -mm tree.  Its filename is
     procfs-guide-drop-pointless-nbsp-entities.patch

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
Subject: procfs-guide: drop pointless &nbsp; entities
From: Mike Frysinger <vapier@gentoo.org>

Having trailing &nbsp; entities in a revision numer seems pretty pointless
to me.  More so, it's causing me pains, so just drop them since no other
guide is doing this.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/procfs-guide.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/procfs-guide.tmpl~procfs-guide-drop-pointless-nbsp-entities Documentation/DocBook/procfs-guide.tmpl
--- a/Documentation/DocBook/procfs-guide.tmpl~procfs-guide-drop-pointless-nbsp-entities
+++ a/Documentation/DocBook/procfs-guide.tmpl
@@ -29,12 +29,12 @@
 
     <revhistory>
       <revision>
-	<revnumber>1.0&nbsp;</revnumber>
+	<revnumber>1.0</revnumber>
 	<date>May 30, 2001</date>
 	<revremark>Initial revision posted to linux-kernel</revremark>
       </revision>
       <revision>
-	<revnumber>1.1&nbsp;</revnumber>
+	<revnumber>1.1</revnumber>
 	<date>June 3, 2001</date>
 	<revremark>Revised after comments from linux-kernel</revremark>
       </revision>
_

Patches currently in -mm which might be from vapier@gentoo.org are

uio-howtotmpl-use-standard-copyright-legal-markings.patch
uio-howtotmpl-use-unique-output-names.patch
procfs-guide-drop-pointless-nbsp-entities.patch

