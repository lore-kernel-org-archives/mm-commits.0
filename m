From: akpm@linux-foundation.org
Subject: - cpusets-provide-another-web-page-url-in-maintainers-file.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:13 -0700
Message-ID: <200806160603.m5G63DWG010581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbYFPGDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: provide another web page URL in MAINTAINERS file
has been removed from the -mm tree.  Its filename was
     cpusets-provide-another-web-page-url-in-maintainers-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: provide another web page URL in MAINTAINERS file
From: Paul Jackson <pj@sgi.com>

Add URL for another CPUSETS web page to the MAINTAINERS file.

This URL provides links to major LGPL user level C libraries supporting
cpuset usage and user level cpu and node masks.

Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~cpusets-provide-another-web-page-url-in-maintainers-file MAINTAINERS
--- a/MAINTAINERS~cpusets-provide-another-web-page-url-in-maintainers-file
+++ a/MAINTAINERS
@@ -1202,6 +1202,7 @@ M:	pj@sgi.com
 M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
+W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
 
 CRAMFS FILESYSTEM
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
linux-next.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

