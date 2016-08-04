From: akpm@linux-foundation.org
Subject: + maintainers-update-cgroups-document-path.patch added to -mm
 tree
Date: Thu, 04 Aug 2016 14:07:47 -0700
Message-ID: <57a3aea3.WoD44MDuMjfmhwPx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbcHDVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamyooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update cgroup's document path
has been added to the -mm tree.  Its filename is
     maintainers-update-cgroups-document-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-cgroups-document-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-cgroups-document-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-update-cgroups-document-path.patch

