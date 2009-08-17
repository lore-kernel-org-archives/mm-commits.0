From: akpm@linux-foundation.org
Subject: + documentation-vm-gitignore-add-page-types.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:50:40 -0700
Message-ID: <200908172350.n7HNoeJ9022275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbZHQXuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@joshtriplett.org, fengguang.wu@intel.com


The patch titled
     Documentation/vm/.gitignore: add page-types
has been added to the -mm tree.  Its filename is
     documentation-vm-gitignore-add-page-types.patch

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
Subject: Documentation/vm/.gitignore: add page-types
From: Josh Triplett <josh@joshtriplett.org>

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/vm/.gitignore~documentation-vm-gitignore-add-page-types Documentation/vm/.gitignore
--- a/Documentation/vm/.gitignore~documentation-vm-gitignore-add-page-types
+++ a/Documentation/vm/.gitignore
@@ -1 +1,2 @@
+page-types
 slabinfo
_

Patches currently in -mm which might be from josh@joshtriplett.org are

documentation-vm-gitignore-add-page-types.patch

