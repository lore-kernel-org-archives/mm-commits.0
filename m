From: akpm@linux-foundation.org
Subject: - cpusets-update-maintainers.patch removed from -mm tree
Date: Fri, 02 May 2008 12:41:41 -0700
Message-ID: <200805021941.m42JffeZ011101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159AbYEBTmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, menage@google.com, mingo@elte.hu, simon.derr@bull.net, mm-commits@vger.kernel.org


The patch titled
     cpusets: update maintainers
has been removed from the -mm tree.  Its filename was
     cpusets-update-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: update maintainers
From: Paul Jackson <pj@sgi.com>

Update CPUSETS MAINTAINERS to reflect the more active role of Paul Menage
(secondary to his work on cgroups) and the retirement of the original author
of cpusets, Simon Derr.  Thanks, Simon!  Best of luck to you.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Simon Derr <simon.derr@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~cpusets-update-maintainers MAINTAINERS
--- a/MAINTAINERS~cpusets-update-maintainers
+++ a/MAINTAINERS
@@ -1196,9 +1196,9 @@ S:	Maintained
 
 CPUSETS
 P:	Paul Jackson
-P:	Simon Derr
+P:	Paul Menage
 M:	pj@sgi.com
-M:	simon.derr@bull.net
+M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 S:	Supported
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
git-sched.patch

