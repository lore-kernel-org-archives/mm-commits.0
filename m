From: akpm@linux-foundation.org
Subject: - feature-removal-scheduletxt-delete-completed-ppc-removal-task.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:32:37 -0700
Message-ID: <200808122032.m7CKWbnl011725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbYHLUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     feature-removal-schedule.txt: delete completed "ppc removal" task
has been removed from the -mm tree.  Its filename was
     feature-removal-scheduletxt-delete-completed-ppc-removal-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
