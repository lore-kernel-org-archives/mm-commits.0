From: akpm@linux-foundation.org
Subject: - cpusets-remove-pj-from-cpuset-maintainers.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:13 -0700
Message-ID: <200810072339.m97NdDNl009536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYJGXjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, dfults@sgi.com, jh@sgi.com, menage@google.com, pj@usa.net, mm-commits@vger.kernel.org


The patch titled
     cpusets: remove pj from cpuset maintainers
has been removed from the -mm tree.  Its filename was
     cpusets-remove-pj-from-cpuset-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: remove pj from cpuset maintainers
From: Paul Jackson <pj@sgi.com>

Remove myself from the kernel MAINTAINERS file for cpusets.  I am leaving
SGI and probably will not be active in Linux kernel work.  I can be
reached at <pj@usa.net>.  Contact Derek Fults <dfults@sgi.com> for future
SGI+cpuset related issues.  I'm off to the next chapter of this good life.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Cc: John Hesterberg <jh@sgi.com>
Cc: Paul Jackson <pj@usa.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~cpusets-remove-pj-from-cpuset-maintainers MAINTAINERS
--- a/MAINTAINERS~cpusets-remove-pj-from-cpuset-maintainers
+++ a/MAINTAINERS
@@ -1198,9 +1198,7 @@ M:	hpa@zytor.com
 S:	Maintained
 
 CPUSETS
-P:	Paul Jackson
 P:	Paul Menage
-M:	pj@sgi.com
 M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
_

Patches currently in -mm which might be from pj@sgi.com are

cpuset-use-seq_cpumask-seq_nodemask.patch
cpusetc-remove-extra-variable.patch

