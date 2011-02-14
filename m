From: akpm@linux-foundation.org
Subject: + maintainers-add-topgit-for-t.patch added to -mm tree
Date: Mon, 14 Feb 2011 13:54:56 -0800
Message-ID: <201102142154.p1ELsvwt027845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab1BNW1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 17:27:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiaweiwei.xiyou@gmail.com, harryxiyou@gmail.com


The patch titled
     MAINTAINERS: add topgit for T:
has been added to the -mm tree.  Its filename is
     maintainers-add-topgit-for-t.patch

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
Subject: MAINTAINERS: add topgit for T:
From: Harry Wei <jiaweiwei.xiyou@gmail.com>

At least one tree:

	ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)

is available via topgit.  Add mention of topgit in the MAINTAINERS
description section.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-topgit-for-t MAINTAINERS
--- a/MAINTAINERS~maintainers-add-topgit-for-t
+++ a/MAINTAINERS
@@ -72,7 +72,7 @@ Descriptions of section entries:
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
-	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
_

Patches currently in -mm which might be from jiaweiwei.xiyou@gmail.com are

linux-next.patch
maintainers-add-topgit-for-t.patch

