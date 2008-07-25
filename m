From: akpm@linux-foundation.org
Subject: - procfs-guide-drop-pointless-nbsp-entities.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:58 -0700
Message-ID: <200807252257.m6PMvw4i003240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540AbYGYXHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     procfs-guide: drop pointless &nbsp; entities
has been removed from the -mm tree.  Its filename was
     procfs-guide-drop-pointless-nbsp-entities.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

