From: akpm@linux-foundation.org
Subject: + documentation-codingstyle-flesh-out-if-else-examples.patch added to -mm tree
Date: Tue, 22 Feb 2011 17:15:47 -0800
Message-ID: <201102230115.p1N1FlGW007114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab1BWBQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Feb 2011 20:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiaweiwei.xiyou@gmail.com, harryxiyou@gmail.com, randy.dunlap@oracle.com


The patch titled
     Documentation/CodingStyle: flesh out if-else examples
has been added to the -mm tree.  Its filename is
     documentation-codingstyle-flesh-out-if-else-examples.patch

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
Subject: Documentation/CodingStyle: flesh out if-else examples
From: Harry Wei <jiaweiwei.xiyou@gmail.com>

There is a missing case for "Chapter 3: Placing Braces and Spaces".  We
often know we should not use braces where a single statement.  The first
case is:

	if (condition)
		action();

Another case is:

	if (condition)
		do_this();
	else
		do_that();

However, I can not find a description of the second case.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/CodingStyle~documentation-codingstyle-flesh-out-if-else-examples Documentation/CodingStyle
--- a/Documentation/CodingStyle~documentation-codingstyle-flesh-out-if-else-examples
+++ a/Documentation/CodingStyle
@@ -168,6 +168,13 @@ Do not unnecessarily use braces where a 
 if (condition)
 	action();
 
+and
+
+if (condition)
+	do_this();
+else
+	do_that();
+
 This does not apply if one branch of a conditional statement is a single
 statement. Use braces in both branches.
 
_

Patches currently in -mm which might be from jiaweiwei.xiyou@gmail.com are

linux-next.patch
maintainers-add-chinese-documentation-maintainer.patch
maintainers-add-topgit-for-t.patch
documentation-codingstyle-flesh-out-if-else-examples.patch

