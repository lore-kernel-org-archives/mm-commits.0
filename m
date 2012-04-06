From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-entry-for-sparse-checker.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:49:07 -0700
Message-ID: <20120406184907.6ED98A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47480 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2DFStJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:49:09 -0400
Received: by qcsp5 with SMTP id p5so300113qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:49:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sparse@chrisli.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for sparse checker
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-sparse-checker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christopher Li <sparse@chrisli.org>
Subject: MAINTAINERS: add entry for sparse checker

Signed-off-by: Christopher Li <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-sparse-checker MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-sparse-checker
+++ a/MAINTAINERS
@@ -6287,6 +6287,15 @@ F:	drivers/tty/serial/sunsu.c
 F:	drivers/tty/serial/sunzilog.c
 F:	drivers/tty/serial/sunzilog.h
 
+SPARSE CHECKER
+M:	"Christopher Li" <sparse@chrisli.org>
+L:	linux-sparse@vger.kernel.org
+W:	https://sparse.wiki.kernel.org/
+T:	git git://git.kernel.org/pub/scm/devel/sparse/sparse.git
+T:	git git://git.kernel.org/pub/scm/devel/sparse/chrisl/sparse.git
+S:	Maintained
+F:	include/linux/compiler.h
+
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
 L:	spear-devel@list.st.com
_

Patches currently in -mm which might be from sparse@chrisli.org are

origin.patch

