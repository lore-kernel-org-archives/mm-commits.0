From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:39 -0700
Message-ID: <200906171838.n5HIcdE8004637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760790AbZFQSjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add Paul McKenney to RCU and RCUTORTURE
has been removed from the -mm tree.  Its filename was
     maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add Paul McKenney to RCU and RCUTORTURE
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~maintainers-add-paul-mckenney-to-rcu-and-rcutorture MAINTAINERS
--- a/MAINTAINERS~maintainers-add-paul-mckenney-to-rcu-and-rcutorture
+++ a/MAINTAINERS
@@ -4779,6 +4779,8 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
+P:	Paul E. McKenney
+M:	paulmck@linux.vnet.ibm.com
 S:	Maintained
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
@@ -4805,6 +4807,8 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
 M:	dipankar@in.ibm.com
+P:	Paul E. McKenney
+M:	paulmck@linux.vnet.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
 F:	Documentation/RCU/rcu.txt
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

