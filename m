From: akpm@linux-foundation.org
Subject: [merged] documentation-codingstyle-flesh-out-if-else-examples.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:58 -0700
Message-ID: <201103232044.p2NKiYRv029085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933468Ab1CWUoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiaweiwei.xiyou@gmail.com, harryxiyou@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/CodingStyle: flesh out if-else examples
has been removed from the -mm tree.  Its filename was
     documentation-codingstyle-flesh-out-if-else-examples.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

