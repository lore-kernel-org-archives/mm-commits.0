From: akpm@linux-foundation.org
Subject: [patch 6/7] MAINTAINERS: update cgroup's document path
Date: Thu, 04 Aug 2016 15:31:57 -0700
Message-ID: <57a3c25d.TytYVlEDXO7brg6g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbcHDWb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 18:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamyooon@gmail.com

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
