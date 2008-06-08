From: akpm@linux-foundation.org
Subject: - doc-update-to-url-and-status-of-kernel-docstxt-entry.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:36 -0700
Message-ID: <200806081947.m58Jla01017430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbYFHTrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     doc: update to URL and status of kernel-docs.txt entry
has been removed from the -mm tree.  Its filename was
     doc-update-to-url-and-status-of-kernel-docstxt-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: update to URL and status of kernel-docs.txt entry
From: Paul Jackson <pj@sgi.com>

Update status and URL for the "Gary's Encyclopedia" entry.

Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-docs.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-docs.txt~doc-update-to-url-and-status-of-kernel-docstxt-entry Documentation/kernel-docs.txt
--- a/Documentation/kernel-docs.txt~doc-update-to-url-and-status-of-kernel-docstxt-entry
+++ a/Documentation/kernel-docs.txt
@@ -715,14 +715,14 @@
 
      * Name: "Gary's Encyclopedia - The Linux Kernel"
        Author: Gary (I suppose...).
-       URL: http://www.lisoleg.net/cgi-bin/lisoleg.pl?view=kernel.htm
-       Keywords: links, not found here?.
+       URL: http://slencyclopedia.berlios.de/index.html
+       Keywords: linux, community, everything!
        Description: Gary's Encyclopedia exists to allow the rapid finding
        of documentation and other information of interest to GNU/Linux
        users. It has about 4000 links to external pages in 150 major
        categories. This link is for kernel-specific links, documents,
-       sites... Look there if you could not find here what you were
-       looking for.
+       sites...  This list is now hosted by developer.Berlios.de,
+       but seems not to have been updated since sometime in 1999.
 
      * Name: "The home page of Linux-MM"
        Author: The Linux-MM team.
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
linux-next.patch
sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

