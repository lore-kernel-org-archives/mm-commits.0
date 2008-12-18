From: akpm@linux-foundation.org
Subject: + inotify-maintainer-email-fixes.patch added to -mm tree
Date: Wed, 17 Dec 2008 22:09:43 -0800
Message-ID: <200812180609.mBI69hQs029289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbYLRGKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 01:10:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john@johnmccutchan.com, rlove@rlove.org


The patch titled
     inotify: maintainer email fixes
has been added to the -mm tree.  Its filename is
     inotify-maintainer-email-fixes.patch

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
Subject: inotify: maintainer email fixes
From: "John McCutchan" <john@johnmccutchan.com>

Update John McCutchan and Robert Love's email addresses for
maintenance of inotify

Signed-off-by: John McCutchan <john@johnmccutchan.com>
Acked-by: Robert Love <rlove@rlove.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~inotify-maintainer-email-fixes MAINTAINERS
--- a/MAINTAINERS~inotify-maintainer-email-fixes
+++ a/MAINTAINERS
@@ -2184,9 +2184,9 @@ S:	Supported
 
 INOTIFY
 P:	John McCutchan
-M:	ttb@tentacle.dhs.org
+M:	john@johnmccutchan.com
 P:	Robert Love
-M:	rml@novell.com
+M:	rlove@rlove.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
_

Patches currently in -mm which might be from john@johnmccutchan.com are

inotify-maintainer-email-fixes.patch
inotify-fix-type-errors-in-interfaces.patch

