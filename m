From: akpm@linux-foundation.org
Subject: + cpusets-provide-another-web-page-url-in-maintainers-file.patch added to -mm tree
Date: Mon, 09 Jun 2008 15:55:16 -0700
Message-ID: <200806092255.m59MtGxv012887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbYFIWzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 18:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com


The patch titled
     cpusets: provide another web page URL in MAINTAINERS file
has been added to the -mm tree.  Its filename is
     cpusets-provide-another-web-page-url-in-maintainers-file.patch

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
@@ -1207,6 +1207,7 @@ M:	pj@sgi.com
 M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
+W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
 
 CRAMFS FILESYSTEM
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
cpusets-provide-another-web-page-url-in-maintainers-file.patch
linux-next.patch
sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

