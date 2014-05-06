From: akpm@linux-foundation.org
Subject: + maintainers-update-maintainership-of-ltp.patch added to -mm
 tree
Date: Tue, 06 May 2014 14:05:33 -0700
Message-ID: <53694e9d.AOEe075CNjKaz5+2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaEFVFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 17:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stanislav.kholmanskikh@oracle.com, jstancek@redhat.com, gaowanlong@cn.fujitsu.com, caspar@casparzhang.com, alexey.kodanev@oracle.com, chrubis@suse.cz

Subject: + maintainers-update-maintainership-of-ltp.patch added to -mm tree
To: chrubis@suse.cz,alexey.kodanev@oracle.com,caspar@casparzhang.com,gaowanlong@cn.fujitsu.com,jstancek@redhat.com,stanislav.kholmanskikh@oracle.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 14:05:33 -0700


The patch titled
     Subject: MAINTAINERS: update maintainership of LTP
has been added to the -mm tree.  Its filename is
     maintainers-update-maintainership-of-ltp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-maintainership-of-ltp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-maintainership-of-ltp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-update-maintainership-of-ltp.patch

