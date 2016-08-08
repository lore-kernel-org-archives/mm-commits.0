From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-cgroups-document-path.patch removed
 from -mm tree
Date: Mon, 08 Aug 2016 13:15:17 -0700
Message-ID: <57a8e855.pPNwawrGB7zLZ/ZW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcHHUPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2016 16:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamyooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update cgroup's document path
has been removed from the -mm tree.  Its filename was
     maintainers-update-cgroups-document-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "seokhoon.yoon" <iamyooon@gmail.com>
Subject: MAINTAINERS: update cgroup's document path

cgroup's document path is changed to "cgroup-v1". update it.

Link: http://lkml.kernel.org/r/1470322507-5161-1-git-send-email-iamyooon@gmail.com
Signed-off-by: seokhoon.yoon <iamyooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-cgroups-document-path MAINTAINERS
--- a/MAINTAINERS~maintainers-update-cgroups-document-path
+++ a/MAINTAINERS
@@ -3219,7 +3219,7 @@ M:	Johannes Weiner <hannes@cmpxchg.org>
 L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
-F:	Documentation/cgroups/
+F:	Documentation/cgroup*
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
 
@@ -3230,7 +3230,7 @@ W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
-F:	Documentation/cgroups/cpusets.txt
+F:	Documentation/cgroup-v1/cpusets.txt
 F:	include/linux/cpuset.h
 F:	kernel/cpuset.c
 
_

Patches currently in -mm which might be from iamyooon@gmail.com are


