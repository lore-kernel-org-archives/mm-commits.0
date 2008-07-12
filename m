From: akpm@linux-foundation.org
Subject: + oprofile-kernel-maintainership-changes.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:58:02 -0700
Message-ID: <200807120058.m6C0w27Z013380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbYGLA73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.richter@amd.com, akpm@linux-foundation.org, daniel.hansel@linux.vnet.ibm.com, jason.yeh@amd.com, levon@movementarian.org, maynardj@us.ibm.com, phil.el@wanadoo.fr, rpurdie@openedhand.com


The patch titled
     OProfile kernel maintainership changes
has been added to the -mm tree.  Its filename is
     oprofile-kernel-maintainership-changes.patch

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
Subject: OProfile kernel maintainership changes
From: Robert Richter <robert.richter@amd.com>

Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: John Levon <levon@movementarian.org>
Cc: Maynard Johnson <maynardj@us.ibm.com>
Cc: Richard Purdie <rpurdie@openedhand.com>
Cc: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
Cc: Jason Yeh <jason.yeh@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~oprofile-kernel-maintainership-changes MAINTAINERS
--- a/MAINTAINERS~oprofile-kernel-maintainership-changes
+++ a/MAINTAINERS
@@ -3141,8 +3141,8 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
 OPROFILE
-P:	Philippe Elie
-M:	phil.el@wanadoo.fr
+P:	Robert Richter
+M:	robert.richter@amd.com
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 
_

Patches currently in -mm which might be from robert.richter@amd.com are

linux-next.patch
oprofile-kernel-maintainership-changes.patch

