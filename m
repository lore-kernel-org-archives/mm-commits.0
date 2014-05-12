From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-maintainership-of-ltp.patch removed
 from -mm tree
Date: Mon, 12 May 2014 12:30:45 -0700
Message-ID: <53712165.J6EmVZpFsu6p7/tC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaELTaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 15:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stanislav.kholmanskikh@oracle.com, jstancek@redhat.com, gaowanlong@cn.fujitsu.com, caspar@casparzhang.com, alexey.kodanev@oracle.com, chrubis@suse.cz

Subject: [merged] maintainers-update-maintainership-of-ltp.patch removed from -mm tree
To: chrubis@suse.cz,alexey.kodanev@oracle.com,caspar@casparzhang.com,gaowanlong@cn.fujitsu.com,jstancek@redhat.com,stanislav.kholmanskikh@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 12:30:45 -0700


The patch titled
     Subject: MAINTAINERS: update maintainership of LTP
has been removed from the -mm tree.  Its filename was
     maintainers-update-maintainership-of-ltp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyril Hrubis <chrubis@suse.cz>
Subject: MAINTAINERS: update maintainership of LTP

Also remove sf.net git repo which is no longer available and update link
to LTP web pages.

Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-update-maintainership-of-ltp MAINTAINERS
--- a/MAINTAINERS~maintainers-update-maintainership-of-ltp
+++ a/MAINTAINERS
@@ -5488,15 +5488,15 @@ F:	Documentation/hwmon/ltc4261
 F:	drivers/hwmon/ltc4261.c
 
 LTP (Linux Test Project)
-M:	Shubham Goyal <shubham@linux.vnet.ibm.com>
 M:	Mike Frysinger <vapier@gentoo.org>
 M:	Cyril Hrubis <chrubis@suse.cz>
-M:	Caspar Zhang <caspar@casparzhang.com>
 M:	Wanlong Gao <gaowanlong@cn.fujitsu.com>
+M:	Jan Stancek <jstancek@redhat.com>
+M:	Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
+M:	Alexey Kodanev <alexey.kodanev@oracle.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
-W:	http://ltp.sourceforge.net/
+W:	http://linux-test-project.github.io/
 T:	git git://github.com/linux-test-project/ltp.git
-T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
 M32R ARCHITECTURE
_

Patches currently in -mm which might be from chrubis@suse.cz are

origin.patch

