From: akpm@linux-foundation.org
Subject: +
 documentation-codingstyle-allow-multiple-return-statements-per-function.patch added to -mm tree
Date: Mon, 20 May 2013 13:05:08 -0700
Message-ID: <519a81f4.aif3yD/xV4/cFkOW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3ETUFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 16:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, eduardo.valentin@ti.com, dan.carpenter@oracle.com

Subject: + documentation-codingstyle-allow-multiple-return-statements-per-function.patch added to -mm tree
To: dan.carpenter@oracle.com,eduardo.valentin@ti.com,rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 13:05:08 -0700


The patch titled
     Subject: Documentation/CodingStyle: allow multiple return statements per function
has been added to the -mm tree.  Its filename is
     documentation-codingstyle-allow-multiple-return-statements-per-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Documentation/CodingStyle: allow multiple return statements per function

A surprising number of newbies interpret this section to mean that only
one return statement is allowed per function.  Part of the problem is that
the "one return statement per function" rule is an actual style guideline
that people are used to from other projects.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/CodingStyle~documentation-codingstyle-allow-multiple-return-statements-per-function Documentation/CodingStyle
--- a/Documentation/CodingStyle~documentation-codingstyle-allow-multiple-return-statements-per-function
+++ a/Documentation/CodingStyle
@@ -389,7 +389,8 @@ Albeit deprecated by some people, the eq
 used frequently by compilers in form of the unconditional jump instruction.
 
 The goto statement comes in handy when a function exits from multiple
-locations and some common work such as cleanup has to be done.
+locations and some common work such as cleanup has to be done.  If there is no
+cleanup needed then just return directly.
 
 The rationale is:
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
configfs-use-capped-length-for-store_attribute.patch
errh-is_err-can-accept-__user-pointers.patch
rbtree-remove-unneeded-include.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

