From: akpm@linux-foundation.org
Subject: + feature-removal-scheduletxt-delete-completed-ppc-removal-task.patch added to -mm tree
Date: Mon, 11 Aug 2008 14:52:06 -0700
Message-ID: <200808112152.m7BLq6xt023380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbYHKVwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 17:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, benh@kernel.crashing.org


The patch titled
     feature-removal-schedule.txt: delete completed "ppc removal" task
has been added to the -mm tree.  Its filename is
     feature-removal-scheduletxt-delete-completed-ppc-removal-task.patch

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
Subject: feature-removal-schedule.txt: delete completed "ppc removal" task
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~feature-removal-scheduletxt-delete-completed-ppc-removal-task Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~feature-removal-scheduletxt-delete-completed-ppc-removal-task
+++ a/Documentation/feature-removal-schedule.txt
@@ -189,19 +189,6 @@ Who:  Tejun Heo <htejun@gmail.com>
 
 ---------------------------
 
-What: The arch/ppc and include/asm-ppc directories
-When: Jun 2008
-Why:  The arch/powerpc tree is the merged architecture for ppc32 and ppc64
-      platforms.  Currently there are efforts underway to port the remaining
-      arch/ppc platforms to the merged tree.  New submissions to the arch/ppc
-      tree have been frozen with the 2.6.22 kernel release and that tree will
-      remain in bug-fix only mode until its scheduled removal.  Platforms
-      that are not ported by June 2008 will be removed due to the lack of an
-      interested maintainer.
-Who:  linuxppc-dev@ozlabs.org
-
----------------------------
